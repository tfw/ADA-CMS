task :nesstar => :environment do
  Nesstar::Integration.run
end

task :fetch_rdf do
  include FileUtils::Verbose
  nesstar_url = "http://bonus.anu.edu.au/obj/fStudyHome/StudyHome?http%3A%2F%2Fwww.nesstar.org%2Frdf%2Fmethod=http%3A%2F%2Fwww.nesstar.org%2Frdf%2FDatasetHome%2FEJBQuery&http%3A%2F%2Fwww.nesstar.org%2Frdf%2FDatasetHome%2FEJBQuery%23query=SELECT+OBJECT(o)+FROM+Study+o+WHERE+o.abstractText+like+%27%25aborigin%25%27"

  rm_rf("tmp/nesstar")
  mkdir("tmp/nesstar")
  begin
    `curl -o tmp/nesstar/payload.xml --compressed "#{nesstar_url}"`
    `echo #{Time.now.strftime("%Y-%m-%d %I:%M")} > tmp/nesstar/payload_success.txt`
  rescue StandardError => boom
    `echo #{Time.now.strftime("%Y-%m-%d %I:%M")} > tmp/nesstar/payload_failure.txt`
    `echo "\n\n Exception: #{boom.to_s}" >> tmp/nesstar/payload_failure.txt`
  end
end


#these tasks set up data in the system for use when developing the integration layer
task :sample_query => :environment do
    ArchiveStudyQuery.create!(:name => "default", 
              :query => "http://palo.anu.edu.au/obj/fStudyHome/StudyHome?http%3A%2F%2Fwww.nesstar.org%2Frdf%2Fmethod=http%3A%2F%2Fwww.nesstar.org%2Frdf%2FDatasetHome%2FEJBQuery&http%3A%2F%2Fwww.nesstar.org%2Frdf%2FDatasetHome%2FEJBQuery%23query=SELECT+OBJECT(o)+FROM+Study+o+WHERE+o.abstractText+like+%27%25aborigin%25%27",
              :archive => Archive.indigenous)
end

task :global_query => :environment do
  ArchiveStudyQuery.create!(:name => "nesstar global", 
            :query => "http://palo.anu.edu.au/obj/fStudyHome/StudyHome?http://www.nesstar.org/rdf/method=http://www.nesstar.org/rdf/DatasetHome/findAll&complete=yes",
            :archive => Archive.ada)
  
  # http:// nesstar.assda.edu.au/obj/fStudyHome/StudyHome?http://www.nesstar.org/rdf/method=http://www.nesstar.org/rdf/DatasetHome/findAll&complete=yes
end

task :sample_study => :environment do
  archive_study_integration = ArchiveStudyIntegration.create!(:ddi_id => "00103", :archive => Archive.international, :user_id => Inkling::User.first.id)
  puts "ArchiveStudyIntegration created between #{archive_study_integration.ddi_id} and the International archive."

  archive_study_integration = ArchiveStudyIntegration.create!(:ddi_id => "00103", :archive => Archive.social_science, :user_id => Inkling::User.first.id)
  puts "ArchiveStudyIntegration created between #{archive_study_integration.ddi_id} and the Social Science archive. "
  puts "Run 'rake nesstar' to create and reference the study to the archive."
end
