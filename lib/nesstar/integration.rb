require 'rubygems'
require 'ruote/engine'
require 'nesstar/config'
require 'ruote/storage/base'
require 'ruote/storage/fs_storage'
require 'ruote/worker'
require 'ruote/participant'
require 'ruote'
require 'fileutils'
require 'yaml'

# require 'ruby-debug'

module Nesstar
  class Integration
    include Config

    #helper method - takes a url like http://palo.anu.edu.au:80/obj/fStudy/au.edu.anu.assda.ddi.00570@relatedMaterials
    #and returns 00570_relatedMaterials.xml
    def self.related_materials_document_id(url)
      trailer = url.split(".").last
      id = trailer.split("@").first
      return id
    end

    #call this from the client to run the integration.
    def self.run
      @storage = Ruote::FsStorage.new("/tmp/nesstar/ruote/")
      @worker = Ruote::Worker.new(@storage)
      @engine = Ruote::Engine.new(@worker)

      register_workflow_participants(@engine)

      dataset_process_def = Ruote.process_definition :name => 'convert_datasets' do
        sequence do
          subprocess :ref => 'initialize_directories'
          participant :ref => 'define_study_integrations', :datasets_yaml => $datasets_file
          cancel_process :if => '${f:study_ids.size} == 0'
          participant :ref => 'download_dataset_xmls'
          participant :ref => 'convert_and_find_resources'
          participant :ref => 'ada_archive_contains_all_studies'          
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
          query.save!
          query_response_file = "#{$xml_dir}query_response_#{Time.now.to_i}.xml"

          `curl -o #{query_response_file} --compressed "#{query.query}"`
          handler = Nesstar::QueryResponseParser.new(query_response_file)

          for url in handler.datasets
            ddi_id = url.split(".").last
            #the validations on the object ensure we don't duplicate the object (archive + query must be unique, url can repeat)
            # puts ddi_id
            pre_existing = ArchiveStudyIntegration.find_by_archive_id_and_ddi_id(query.archive.id, ddi_id)
            unless pre_existing
              ArchiveStudyIntegration.create!(:ddi_id => ddi_id, :archive => query.archive,
                                            :archive_study_query => query, :user_id => query.id)
            end
          end
        end
      end

      ## download_dataset_xmls
      engine.register_participant 'download_dataset_xmls' do |workitem|
        fetch_errors = []
        downloaded_files = []
        
        archive_integrations = Set.new        
        ArchiveStudyIntegration.all.each{|integration| archive_integrations << integration}
        
        archive_integrations.each do |archive_integration|
          ddi_id = archive_integration.ddi_id
          file_name = "#{ddi_id}.xml"

          http_headers = `curl -i --compressed "http://palo.anu.edu.au:80/obj/fStudy/au.edu.anu.assda.ddi.#{ddi_id}"`
          http_headers = http_headers.split("\n")
          
          if http_headers.first =~ /500/
            fetch_errors << "Error while downloading #{ddi_id}: #{http_headers.first} \n"
            # puts "\n\n found an error, not downloading file, for #{ddi_id}"
            next
          end
          
          begin
            `curl -o #{$xml_dir}#{file_name} --compressed "http://palo.anu.edu.au:80/obj/fStudy/au.edu.anu.assda.ddi.#{ddi_id}"`
            downloaded_files << file_name
          rescue StandardError => boom
            puts "#{boom}.to_s"
            fetch_errors << "Error while downloading #{ddi_id}: #{boom} \n"
          end
        end

        workitem.fields['fetch_errors'] = fetch_errors
        workitem.fields['downloads'] = downloaded_files
      end

      ## convert
      engine.register_participant 'convert_and_find_resources' do |workitem|
        database_errors = []

        Dir.entries($xml_dir).each do |file_name|
          next if file_name == "." or file_name == ".."
          study_hash = RDF::Parser.parse("#{$xml_dir}/#{file_name}")
          study = Study.store_with_entries(study_hash)

          #find study integrations which need to be linked to the archive
          integrations = ArchiveStudyIntegration.find_all_by_ddi_id_and_study_id(study.ddi_id, nil)

          for integration in integrations
            integration.study_id = study.id
            integration.save!
          end

          DDIMapping.batch_create(study_hash) #create mappings entries for any DDI elements/attributes we have not yet noticed

          #we looks for a study which records the URL of a related materials document
          related_materials_entry = study.related_materials_attribute
          unless related_materials_entry.nil?
            document_name = related_materials_document_id(related_materials_entry.value) + ".xml"
            `curl -o #{$xml_dir}#{document_name} --compressed "#{related_materials_entry.value}"`
            related_materials_list = RDF::Parser.parse_related_materials_document("#{$xml_dir}/#{document_name}")

            related_materials_list.each do |related|
              pre_existing = StudyRelatedMaterial.find_by_study_id_and_uri(study.id, related[:uri], related[:label])
              next if pre_existing

              related_material = StudyRelatedMaterial.new(:study_id => study.id, :uri => related[:uri],
                          :comment => related[:comment], :creation_date => related[:creationDate], :complete => related[:complete],
                          :resource => related[:study_resource])
              related_material.save!
            end
          
            #we looks for a study's variables
            variables_entry = study.variables_attribute
            # puts "****** #{variables_entry.value} ******* \n\n"
          end
          workitem.fields['database_errors'] = database_errors
        end
      end

      engine.register_participant 'ada_archive_contains_all_studies' do |workitem|
        for study in Study.all
          unless Archive.ada.studies.index(study)
            ArchiveStudy.create!(:archive => Archive.ada, :study => study)
          end
        end
      end
    end
  end
end
