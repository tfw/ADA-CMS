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

# require 'ruby-debug'

module Nesstar
  class Integration
    include Config

    @@curl_count = 0

    #helper method - takes a url like http://palo.anu.edu.au:80/obj/fStudy/au.edu.anu.assda.ddi.00570@relatedMaterials
    #and returns 00570_relatedMaterials.xml
    def self.related_materials_document_id(url)
      trailer = url.split(".").last
      id = trailer.split("@").first
      return id
    end

    #call this from the client to run the integration.
    def self.run
      Mutexer.available
      
      @storage = Ruote::FsStorage.new("/tmp/nesstar/ruote/")
      @worker = Ruote::Worker.new(@storage)
      @engine = Ruote::Engine.new(@worker)

      register_workflow_participants(@engine)

      dataset_process_def = Ruote.process_definition :name => 'convert_datasets' do
        sequence do
          subprocess :ref => 'initialize_directories'
          participant :ref => 'load_study_integrations'
          cancel_process :if => '${f:study_ids.size} == 0'

          # unless Rails.env == "development"
            # participant :ref => 'download_dataset_xmls'
          # end

          concurrent_iterator :on_field => 'studies_to_download', :to_f => "study_id" do
            participant :ref => 'download_study' 
            # participant :ref => 'convert_and_find_resources'
          end

        #   participant :ref => 'convert_and_find_resources'
        #   
        #   concurrent_iterator :on_field => 'variable_urls', :to_f => "variable_url" do
        #     participant :ref => 'convert_variable' 
        #   end
        #   
        #   participant :ref => 'ada_archive_contains_all_studies' 
        #   participant :ref => 'log_run'           
        end

        process_definition :name => 'initialize_directories' do
          sequence do
            participant :ref => 'initialize_directory', :dir => $nesstar_dir
            participant :ref => 'mkdir', :dir => $xml_dir
            participant :ref => 'mkdir', :dir => $studies_xml_dir            
            participant :ref => 'mkdir', :dir => $related_xml_dir
            participant :ref => 'mkdir', :dir => $variables_xml_dir
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

      ## load_study_ids
      engine.register_participant 'load_study_integrations' do |workitem|
        dataset_urls = []
        workitem.fields['studies_to_download'] ||= []

        queries = ArchiveStudyQuery.all

        for query in queries
          query.save!
          query_response_file = "#{$xml_dir}query_response_#{Time.now.to_i}.xml"

          # puts "\n\n query statement: curl -o #{query_response_file} --compressed \"#{query.query}\""
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
            workitem.fields['studies_to_download'] << ddi_id
          end
        end
      end

      engine.register_participant 'download_study' do |workitem|
        workitem.fields['fetch_errors']       ||= []
        workitem.fields['downloaded_files']   ||= []
        
        study_id = workitem.fields['study_id']
        file_name = "#{study_id}.xml"
        
        mutex = Mutexer.available
        
        begin
          mutex = Mutexer.available
          sleep 2 if mutex.nil?
        end while mutex.nil? 

        mutex.synchronize do
          @@curl_count += 1
          puts "found a free curl conn #{@@curl_count}"
        
          puts "\\n\n study download: downloading: http://palo.anu.edu.au:80/obj/fStudy/au.edu.anu.assda.ddi.#{study_id}"
          http_headers = `curl -i --compressed "http://palo.anu.edu.au:80/obj/fStudy/au.edu.anu.assda.ddi.#{study_id}"`
          http_headers = http_headers.split("\n")
        
          if http_headers.first =~ /500/
            workitem.fields['fetch_errors'] << "Error while downloading #{study_id}: #{http_headers.first} \n"
            Inkling::Log.create!(:category => "study", :text =>  "HTTP 500 error downloading: http://palo.anu.edu.au:80/obj/fStudy/au.edu.anu.assda.ddi.#{study_id}")
            next
          end
        
          begin
            `curl -o #{$studies_xml_dir}#{file_name} --compressed "http://palo.anu.edu.au:80/obj/fStudy/au.edu.anu.assda.ddi.#{study_id}"`
            workitem.fields['downloaded_files'] << file_name
          rescue StandardError => boom
            puts "#{boom}.to_s"
            workitem.fields['fetch_errors'] << "Error while downloading #{study_id}: #{boom} \n"
          end
        end
        
        # mutex.unlock
        @@curl_count -= 1
        puts "closed curl count - #{@@curl_count}. Finished with #{study_id}"
      end


      ## download_dataset_xmls
      # engine.register_participant 'download_dataset_xmls' do |workitem|
      #   fetch_errors = []
      #   downloaded_files = []
      #   
      #   archive_integrations = Set.new        
      #   ArchiveStudyIntegration.all.each{|integration| archive_integrations << integration}
      #   
      #   archive_integrations.each do |archive_integration|
      #     ddi_id = archive_integration.ddi_id
      #     file_name = "#{ddi_id}.xml"
      # 
      #     puts "\\n\n study download: downloading: http://palo.anu.edu.au:80/obj/fStudy/au.edu.anu.assda.ddi.#{ddi_id}"
      #     http_headers = `curl -i --compressed "http://palo.anu.edu.au:80/obj/fStudy/au.edu.anu.assda.ddi.#{ddi_id}"`
      #     http_headers = http_headers.split("\n")
      #     
      #     if http_headers.first =~ /500/
      #       fetch_errors << "Error while downloading #{ddi_id}: #{http_headers.first} \n"
      #       # puts "\n\n found an error, not downloading file, for #{ddi_id}"
      #       Inkling::Log.create!(:category => "study", :text =>  "HTTP 500 error downloading: http://palo.anu.edu.au:80/obj/fStudy/au.edu.anu.assda.ddi.#{ddi_id}")
      #       next
      #     end
      #     
      #     begin
      #       `curl -o #{$xml_dir}#{file_name} --compressed "http://palo.anu.edu.au:80/obj/fStudy/au.edu.anu.assda.ddi.#{ddi_id}"`
      #       downloaded_files << file_name
      #     rescue StandardError => boom
      #       puts "#{boom}.to_s"
      #       fetch_errors << "Error while downloading #{ddi_id}: #{boom} \n"
      #     end
      #   end
      # 
      #   workitem.fields['fetch_errors'] = fetch_errors
      #   workitem.fields['downloads'] = downloaded_files
      # end

      ## convert
      engine.register_participant 'convert_and_find_resources' do |workitem|
        database_errors = []

        Dir.entries($xml_dir).each do |file_name|
          next if file_name == "." or file_name == ".."
          puts ("#{$xml_dir}#{file_name}")
          
          study_hash = RDF::Parser.parse("#{$xml_dir}#{file_name}")

          study = Study.store_with_fields(study_hash)

          #find study integrations which need to be linked to the archive
          integrations = ArchiveStudyIntegration.find_all_by_ddi_id_and_study_id(study.ddi_id, nil)

          for integration in integrations
            integration.study_id = study.id
            integration.save!
          end

          DdiMapping.batch_create(study_hash) #create mappings entries for any DDI elements/attributes we have not yet noticed

          #we looks for a study which records the URL of a related materials document
          related_materials_entry = study.related_materials_attribute
          unless related_materials_entry.nil?
            document_name = related_materials_document_id(related_materials_entry.value) + ".xml"
            puts "\n\n related material download: #{related_materials_entry.value}"
            `curl -o #{$related_dir}#{document_name} --compressed "#{related_materials_entry.value}"`
            related_materials_list = RDF::Parser.parse_related_materials_document("#{$related_dir}#{document_name}")

            related_materials_list.each do |related|
              pre_existing = StudyRelatedMaterial.find_by_study_id_and_uri(study.id, related[:uri], related[:label])
              next if pre_existing

              related_material = StudyRelatedMaterial.new(:study_id => study.id, :uri => related[:uri],
                          :comment => related[:comment], :creation_date => related[:creationDate], :complete => related[:complete],
                          :resource => related[:study_resource])
              related_material.save!
            end
            
            workitem.fields['variable_urls'] ||= []
            workitem.fields['variable_urls'] << study.variables_attribute.value
          end
          
        workitem.fields['database_errors'] = database_errors        
      end


      engine.register_participant 'convert_variable' do |workitem|
        mutex = Mutexer.available
        
        begin
          mutex = Mutexer.available
          sleep 2 if mutex.nil?
        end while mutex.nil? 
                        
        @@curl_count += 1
        puts "found a free curl conn #{@@curl_count}"
        
        #we looks for a study's variables
        variable_url = workitem.fields['variable_url']
        var_file_name = variable_url.split(".").last

        `curl -o #{$xml_dir}#{var_file_name} --compressed "#{variable_url}"`

        variables_list = RDF::Parser.parse_variables("#{$xml_dir}/#{var_file_name}")
              
        variables_list.each do |var_hash|
          variable = Variable.store_with_fields(var_hash)
        end

        mutex.unlock
        @@curl_count -= 1
        puts "closed curl count - #{@@curl_count}. Finished with #{variable_url}"
    
        workitem.fields['downloaded_variables'] ||= []
        workitem.fields['downloaded_variables'] << variable_url
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
        Inkling::Log.create!(:category => "study", :text =>  "Downloaded #{workitem.fields['downloads'].size} studies. Encountered #{workitem.fields['fetch_errors'].size} errors. There are now #{Study.all.size} studies in ADA.")        
      end
    end
  end
end
