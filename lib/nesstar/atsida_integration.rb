require 'rubygems'
require 'ruote/engine'
require 'ruby-debug'
require 'nesstar/atsida_config'
require 'ruote/storage/base'
require 'ruote/storage/fs_storage'
require 'ruote/worker'
require 'ruote/participant'
require 'ruote'
require 'fileutils'
require 'yaml'
require 'ruby-debug'

module Nesstar
  class AtsidaIntegration
    include AtsidaConfig

    #helper method - takes a url like http://bonus.anu.edu.au:80/obj/fStudy/au.edu.anu.assda.ddi.00570@relatedMaterials
    #and returns 00570_relatedMaterials.xml
    def self.related_materials_document_id(url)
      trailer = url.split(".").last
      id = trailer.split("@").first
      return id
    end

    #call this from the client to run the integration.
    def self.run
      @storage = Ruote::FsStorage.new("/tmp/atsida-ruote/")
      @worker = Ruote::Worker.new(@storage)
      @engine = Ruote::Engine.new(@worker)

      register_workflow_participants(@engine)

      dataset_process_def = Ruote.process_definition :name => 'convert_datasets' do
        sequence do
          subprocess :ref => 'initialize_directories'
          participant :ref => 'define_study_integrations', :datasets_yaml => $datasets_file
          cancel_process :if => '${f:study_ids.size} == 0'
          participant :ref => 'download_dataset_xmls'
          participant :ref => 'convert'
        end

        process_definition :name => 'initialize_directories' do
          sequence do
            participant :ref => 'initialize_directory', :dir => $nesstar_dir
            participant :ref => 'recreate_xml_directory', :dir => $xml_dir
          end
        end
      end

      ARGV << "-d"
      wfid = @engine.launch(dataset_process_def)
      @engine.wait_for(wfid)
    end

    # registers the workflow logic participants with ruote
    def self.register_workflow_participants(engine)
      engine.register_participant 'initialize_directory' do |workitem|
        mkdir(workitem.fields["params"]['dir']) unless File.exists?(workitem.fields["params"]['dir'])
      end

      engine.register_participant 'recreate_xml_directory' do |workitem|
        rm_rf(workitem.fields['params']['dir'])
        mkdir(workitem.fields['params']['dir'])
      end

      ## load_study_ids
      engine.register_participant 'define_study_integrations' do |workitem|
        dataset_urls = []

        queries = ArchiveStudyQuery.all

        for query in queries
          query_response_file = "#{$xml_dir}query_response_#{Time.now.to_i}.xml"
 
          `curl -o #{query_response_file} --compressed "#{query.query}"`
          handler = Nesstar::QueryResponseParser.new(query_response_file)

          for url in handler.datasets
            #the validations on the object ensure we don't duplicate the object (archive + query must be unique, url can repeat)
            ArchiveToStudyIntegration.create(:url => url, :archive => query.archive, :archive_study_query => query) 
          end
        end
      end

      ## download_dataset_xmls
      engine.register_participant 'download_dataset_xmls' do |workitem|
        fetch_errors = []
        
        downloaded_files = []
        
        archive_integrations = Set.new        
        ArchiveToStudyIntegration.all.each{|url| archive_integrations << url}
        
        archive_integrations.each do |archive_integration|
          url = archive_integration.url
          file_name = "#{url.split(".").last}.xml"
          begin
            `curl -o #{$xml_dir}#{file_name} --compressed "#{url}"`
            downloaded_files << file_name
          rescue StandardError => boom
            puts "#{boom}.to_s"
            fetch_errors << "Error while downloading #{url}: #{boom} \n"
          end
        end

        workitem.fields['fetch_errors'] = fetch_errors
        workitem.fields['downloads'] = downloaded_files
      end

      ## convert
      engine.register_participant 'convert' do |workitem|
        database_errors = []
        new_pages = []

        Dir.entries($xml_dir).each do |file_name|
          next if file_name == "." or file_name == ".."
          ds_hash = RDF::Parser.parse("#{$xml_dir}/#{file_name}")
          ds = Study.store_with_entries(ds_hash)
          
          #find study integrations which need to be linked to
          integrations = ArchiveToStudyIntegration.find_all_by_url_and_study_id(ds.about, nil)

          for integration in integrations
            integration.study_id = ds.id
            integration.save!
          end
          
          DDIMapping.batch_create(ds_hash) #create mappings entries for any DDI elements/attributes we have not yet noticed

          #we looks for a dataset_entry which records the URL of a related materials document
          related_materials_entry = ds.related_materials_attribute
          unless related_materials_entry.nil?
            document_name = related_materials_document_id(related_materials_entry.value) + ".xml"
            `curl -o #{$xml_dir}#{document_name} --compressed "#{related_materials_entry.value}"`
            related_materials_list = RDF::Parser.parse_related_materials_document("#{$xml_dir}/#{document_name}")

            related_materials_list.each do |related|
              pre_existing = StudyRelatedMaterial.find_by_study_id_and_uri(ds.id, related[:uri], related[:label])
              next if pre_existing

              related_material = StudyRelatedMaterial.new(:study_id => ds.id, :uri => related[:uri],
                          :comment => related[:comment], :creation_date => related[:creationDate], :complete => related[:complete],
                          :resource => related[:study_resource])
              related_material.save!
          end
        end
        workitem.fields['database_errors'] = database_errors
      end
    end
      
      # engine.register_participant 'create_pages' do |workitem|      
      #   ArchiveToStudyIntegration.all.each do |archive_study_integration|
      #     study = archive_study_integration.study
      #     path = study.label.split(".").last
      #     path.gsub!(/[^\w\s]/, "")
      #     path = path.gsub(" ", "-").downcase
      # 
      #     page = Page.find_by_title_and_archive_id(study.label, archive_study_integration.archive_id)
      #     author = Inkling::Role.find_by_name("administrator").users.first
      # 
      #     if page.nil?
      #       page = Page.create!(:title => study.label, :description => "A page automatically created to hold the #{study.label} dataset.",
      #       :partial =>"study_page.html.erb", :author => author, :archive => archive_study_integration.archive,
      #       :archive_to_study_integration => archive_study_integration)
      # 
      #       page.save!
      #     end
      #   end
      # end  
    end
  end
end
