require 'rubygems'
require 'mutexer'
require 'ruote/engine'
require 'nesstar/config'
require 'ruote/storage/base'
require 'ruote/storage/fs_storage'
require 'ruote/worker'
require 'ruote/participant'
require 'ruote'
require 'fileutils'
require 'yaml'
require 'nesstar/rdf/parser'

#these classes should be loaded by the rails environment via rake
#but multithreading seems to require we explicitly require them
require 'study'
require 'archive_study'
require 'study_field'
# require 'study_related_material'
# require 'variable'
# require 'variable_field'

require 'ruby-debug'

module Nesstar
  class Integration
    include Config

    #call this from the client to run the integration.
    def self.run
      @storage = Ruote::FsStorage.new("/tmp/nesstar/ruote/")
      @worker = Ruote::Worker.new(@storage)
      @engine = Ruote::Engine.new(@worker)

      register_workflow_participants(@engine)

      dataset_process_def = Ruote.process_definition :name => 'convert_datasets' do
        sequence do
          subprocess :ref => 'initialize_directories'
           participant :ref => 'load_archive_catalog_integrations'          
           participant :ref => 'load_study_integrations'
           # cancel_process :if => '${f:study_ids.size} == 0'
          
           concurrent_iterator :on_field => 'studies_to_download', :to_f => "ddi_id" do
              participant :ref => 'download_study' 
            end
           
            # concurrent_iterator :on_field => 'studies_to_download', :to_f => "ddi_id" do
            #   participant :ref => 'download_related_materials' 
            # end
            #            
            # concurrent_iterator :on_field => 'studies_to_download', :to_f => "ddi_id" do
            #   participant :ref => 'download_variables' 
            # end
            #            
            # participant :ref => 'convert_related_materials' 
            # participant :ref => 'convert_variables' 
                       
            participant :ref => 'ada_archive_contains_all_studies' 
                       
           cursor do
             iterator :on_field => 'archive_catalog_integrations', :to_f => "archive_catalog_integration" do
               participant :ref => 'download_and_convert_catalog_tree' 
             end
             
              rewind :if => '${archive_catalog_integrations.size} != 0'
             #rewind :if => '${archive_catalog_integrations.any?}'
         #   _break :if => '${archive_catalog_integrations.size} == 0'
           end

           participant :ref => 'log_run'
         end
 
        process_definition :name => 'initialize_directories' do
          sequence do
            participant :ref => 'initialize_directory', :dir => $nesstar_dir
            participant :ref => 'mkdir', :dir => $xml_dir
            participant :ref => 'mkdir', :dir => $studies_xml_dir            
            participant :ref => 'mkdir', :dir => $related_xml_dir
            participant :ref => 'mkdir', :dir => $variables_xml_dir
            participant :ref => 'mkdir', :dir => $catalogs_xml_dir        
            
            Archive.all.each do |a|
              participant :ref => 'mkdir', :dir => "#{$catalogs_xml_dir}#{a.slug}"                      
            end    
          end
        end
      end

      ARGV << "-d"
      #@engine.noisy = true
      wfid = @engine.launch(dataset_process_def)
      @engine.wait_for(wfid)
    end

    # registers the workflow logic participants with ruote
    def self.register_workflow_participants(engine)
      engine.register_participant 'initialize_directory' do |workitem|
        rm_rf(workitem.fields['params']['dir'])
        mkdir(workitem.fields["params"]['dir']) unless File.exists?(workitem.fields["params"]['dir'])
      end

      engine.register_participant 'recreate_xml_directory' do |workitem|
        rm_rf(workitem.fields['params']['dir'])
        mkdir(workitem.fields['params']['dir'])
      end

      engine.register_participant 'mkdir' do |workitem|
        mkdir(workitem.fields['params']['dir'])
      end

      engine.register_participant 'load_archive_catalog_integrations' do |workitem|
        ids = Set.new
        
        ArchiveCatalogIntegration.all.each do |i| 
          ids << i.id  #the array stores the id the integration, and the position of the catalog entry in parent
                              #the position is always nil for top level catalogs
          #create a duplicate integration for the ADA archive
          ada_integration = ArchiveCatalogIntegration.create!(:url => i.url, :archive => Archive.ada)
          ids << ada_integration.id
        end
                
        workitem.fields['children_to_parents'] = {} #this hash will hold the relationships to build later on
        workitem.fields['archive_catalog_integrations'] = ids
      end

      
      engine.register_participant 'download_and_convert_catalog_tree' do |workitem|
   #     archive_catalog_info = workitem.fields['archive_catalog_integration']
        archive_catalog_integration = ArchiveCatalogIntegration.find(workitem.fields['archive_catalog_integration'])
        archive = archive_catalog_integration.archive

puts "\n -- starting for #{archive_catalog_integration.url} / #{archive_catalog_integration.archive.name}"
        workitem.fields['archive_catalog_integrations'].delete(archive_catalog_integration.id)
puts "removed #{archive_catalog_integration.id} from #{workitem.fields['archive_catalog_integrations']} --"
        file = "#{$catalogs_xml_dir}#{archive.slug}/#{archive_catalog_integration.label}.xml"
        
       `curl -o #{file} --compressed "#{archive_catalog_integration.url}"`
        label_hash = Nesstar::RDF::Parser.parse_catalog("#{file}")
        
        pre_existing_catalog = ArchiveCatalog.find_by_title_and_archive_id(label_hash[:label], archive.id)

        #does a parent exist for this catalog?
        parent_key = archive_catalog_integration.url + "_" + archive.slug
        parent_id = workitem.fields['children_to_parents'][parent_key]
        parent_catalog = ArchiveCatalog.find(parent_id) if parent_id
        
                
        if pre_existing_catalog
puts "found pre_existing for #{label_hash[:label]} in #{archive.name}"
          catalog = pre_existing_catalog
        else
puts "creating catalog for #{label_hash[:label]} in #{archive.name}"
          if parent_id
            catalog = ArchiveCatalog.create(:title => label_hash[:label], :archive => archive, 
              :parent_id => parent_id) 
          else
            catalog = ArchiveCatalog.create(:title => label_hash[:label], :archive => archive)
          end
        end
        
        archive_catalog_integration.archive_catalog = catalog
        archive_catalog_integration.save
        
        #now configure the children onto the catalogue, whether studies or other catalogs
        children_file = "#{$catalogs_xml_dir}#{archive.slug}/#{archive_catalog_integration.label}@children.xml"
        `curl -o #{children_file} --compressed "#{archive_catalog_integration.url}@children"`
        children = Nesstar::RDF::Parser.parse_catalog_children("#{children_file}")
        
        for child in children
          if child[:resource] =~ /fStudy/
            study = Study.find_by_about(child[:resource])
            archive_study = study.for_archive(archive)
            pre_existing = ArchiveCatalogStudy.find_by_archive_study_id_and_archive_catalog_id(archive_study.id, catalog.id)
            
            if pre_existing
              pre_existing.catalog_position = child[:position]
              pre_existing.save!
            else
              archive_catalog_study = ArchiveCatalogStudy.create!(:archive_study => archive_study, :archive_catalog => catalog, :catalog_position => child[:position])
            end
          else #a child catalog, create an integration for it and configure this catalog as its future parent            
            pre_existing_integration = ArchiveCatalogIntegration.find_by_archive_id_and_url(archive.id, child[:resource])            
            integration = pre_existing_integration 
            integration ||= ArchiveCatalogIntegration.create!(:archive => archive, :url => child[:resource]) 
                        
            workitem.fields['archive_catalog_integrations'] << integration.id
puts "added #{integration.id} for archive #{archive.id} --- #{workitem.fields['archive_catalog_integrations']} --- for url #{integration.url}"
            parent_key = integration.url + "_" + archive.slug
            workitem.fields['children_to_parents'][parent_key]= catalog.id #store the parent for future association
          end
        end        
      end
      
      ## load_study_ids
      engine.register_participant 'load_study_integrations' do |workitem|
        dataset_urls = []
        workitem.fields['studies_to_download'] ||= []

        queries = ArchiveStudyQuery.all

        for query in queries
          query.save!
          query_response_file = "#{$xml_dir}query_response_#{Time.now.to_i}.xml"

          `curl -o #{query_response_file} --compressed "#{query.query}"`
          handler = Nesstar::QueryResponseParser.new(query_response_file)

          for url in handler.datasets
            ddi_id = url.split(".").last
            #the validations on the object ensure we don't duplicate the object (archive + query must be unique, url can repeat)
            pre_existing = ArchiveStudyIntegration.find_by_archive_id_and_ddi_id(query.archive.id, ddi_id)
            unless pre_existing
              ArchiveStudyIntegration.create!(:ddi_id => ddi_id, :archive => query.archive,
                                            :archive_study_query => query, :user_id => query.id)
            end
          end
        end
        
        catalogs = ArchiveCatalogIntegration.all
        
        for catalog in catalogs
          archive = catalog.archive
          file = "#{$catalogs_xml_dir}#{archive.slug}/#{catalog.label}@datasets.xml" #request all datasets referenced by this catalog

          `curl -o #{file} --compressed "#{catalog.url}@datasets"`
          studies_in_catalog = Nesstar::RDF::Parser.parse_catalog_children("#{file}")
          
          for study in studies_in_catalog
            ddi_id = study[:resource].split(".").last
            ArchiveStudyIntegration.create!(:ddi_id => ddi_id, :archive => catalog.archive, :archive_catalog_integration_id => catalog.id)
          end
        end
        
        workitem.fields['studies_to_download'] = Set.new
        ArchiveStudyIntegration.all.each do |integration|
          workitem.fields['studies_to_download'] <<  integration.ddi_id
        end
      end

      engine.register_participant 'download_study' do |workitem|
        workitem.fields['fetch_errors']       ||= []
        workitem.fields['downloaded_files']   ||= []
        workitem.fields['study_ids']          ||= Set.new
        
        ddi_id = workitem.fields['ddi_id']
        file_name = "#{ddi_id}.xml"
        
        mutex = Mutexer.wait_for_mutex(2)
        begin
          mutex.synchronize do
            # puts "\\n\n study download: downloading: #{$nesstar_server}/obj/fStudy/au.edu.anu.ada.ddi.#{ddi_id}"
            http_headers = `curl -i --compressed "#{$nesstar_server}/obj/fStudy/au.edu.anu.ada.ddi.#{ddi_id}"`
            http_headers = http_headers.split("\n")
        
            if http_headers.first =~ /500/
              workitem.fields['fetch_errors'] << "Error while downloading #{ddi_id}: #{http_headers.first} \n"
              Inkling::Log.create!(:category => "integration", :text =>  "HTTP 500 error downloading: #{$nesstar_server}/obj/fStudy/au.edu.anu.assda.ddi.#{ddi_id}")
              next
            end
        
            begin
              # puts " #{$nesstar_server}/obj/fStudy/au.edu.anu.ada.ddi.#{ddi_id}"
              `curl -o #{$studies_xml_dir}#{file_name} --compressed "#{$nesstar_server}/obj/fStudy/au.edu.anu.ada.ddi.#{ddi_id}"`
              workitem.fields['downloaded_files'] << file_name
            rescue StandardError => boom
              puts "#{boom}.to_s"
              workitem.fields['fetch_errors'] << "Error while downloading #{ddi_id}: #{boom} \n"
            end

            study_hash = Nesstar::RDF::Parser.parse("#{$studies_xml_dir}#{ddi_id}.xml")
            study = Study.store_with_fields(study_hash)

            DdiMapping.batch_create(study_hash) #create mappings entries for any DDI elements/attributes we have not yet noticed

            #find archive study integrations which need to be linked to the new study
            integrations = ArchiveStudyIntegration.find_all_by_ddi_id_and_study_id(ddi_id, nil)

            for integration in integrations
              integration.study_id = study.id
              integration.save!
            end
          end
        ensure
          ActiveRecord::Base.connection_pool.release_connection
        end
      end

      engine.register_participant 'download_related_materials' do |workitem|
        mutex = Mutexer.wait_for_mutex(2)
        begin
          mutex.synchronize do 
            ddi_id = workitem.fields['ddi_id']
            study = Study.find_by_ddi_id(ddi_id)
            # puts "related materials for #{study.label}"
            #we looks for a study which records the URL of a related materials document
            related_materials_entry = study.related_materials_attribute
            unless related_materials_entry.nil?
              document_name = related_materials_entry.value.split(".").last + ".xml"
              `curl -o #{$related_xml_dir}#{document_name} --compressed "#{related_materials_entry.value}"`
            end
          end
        ensure
          ActiveRecord::Base.connection_pool.release_connection
        end
      end

      engine.register_participant 'download_variables' do |workitem|
        mutex = Mutexer.wait_for_mutex(2)
        
        begin
          mutex.synchronize do                  
            ddi_id = workitem.fields['ddi_id']
            study = Study.find_by_ddi_id(ddi_id)
        
            #we looks for a study's variables
            variable_url = study.variables_attribute.value
            var_file_name = variable_url.split(".").last

            `curl -o #{$variables_xml_dir}#{var_file_name} --compressed "#{variable_url}"`
          end
        ensure
          ActiveRecord::Base.connection_pool.release_connection
        end
      end
      

      engine.register_participant 'convert_related_materials' do |workitem|
        Dir.entries($related_xml_dir).each do |file_name|
          next if file_name == "." or file_name == ".."
          begin
            related_materials_list = RDF::Parser.parse_related_materials_document("#{$related_xml_dir}#{file_name}")
          rescue StandardError => boom
            puts "#{$related_xml_dir}#{file_name}: #{boom}"
          end
          
          if related_materials_list.nil?
             Inkling::Log.create!(:category => "integration", :text => "Empty document: #{$related_xml_dir}#{file_name}")
             next
          end
                    
          related_materials_list.each do |related|
            study = Study.find_by_about(related[:study_resource])
            next if study.nil?

            pre_existing = StudyRelatedMaterial.find_by_study_id_and_uri(study.id, related[:uri], related[:label])
            next if pre_existing

            related_material = StudyRelatedMaterial.new(:study_id => study.id, :uri => related[:uri],
                        :comment => related[:comment], :creation_date => related[:creationDate], :complete => related[:complete],
                        :resource => related[:study_resource])
            related_material.save!
          end
        end
      end

      engine.register_participant 'convert_variables' do |workitem|
        Dir.entries($variables_xml_dir).each do |file_name|
          next if file_name == "." or file_name == ".."
          variables_list = RDF::Parser.parse_variables("#{$variables_xml_dir }/#{file_name}")
          variables_list.each {|var_hash| variable = Variable.store_with_fields(var_hash)}
        end
      end

      engine.register_participant 'ada_archive_contains_all_studies' do |workitem|
        for study in Study.all
          unless Archive.ada.studies.index(study)
            ArchiveStudy.create!(:archive => Archive.ada, :study => study)
          end
        end
      end

      engine.register_participant 'log_run' do |workitem|
        workitem.fields['downloads'] ||= {}
        workitem.fields['fetch_errors'] ||= {}        
        Inkling::Log.create!(:category => "integration", :text =>  "Downloaded #{workitem.fields['downloads'].size} studies. Encountered #{workitem.fields['fetch_errors'].size} errors. There are now #{Study.all.size} studies in ADA.")        
      end
    end
  end
end
