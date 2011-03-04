# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
require 'rake'

Ada::Application.load_tasks

namespace :ada do
  # task :rebuild => ["db:drop", "db:create", "restore_postgres", "db:migrate", "db:seed", "install_theme"]
  task :rebuild => ["db:drop", "db:create", "db:load", "db:migrate", "db:seed"]
end

task :restore_postgres do
  system("psql -d ada_#{Rails.env} < ada_data_13_2_2011.out")
end

task :install_theme => :environment do
  Inkling::Theme.install_from_dir("config/theme")
end

task :nesstar => :environment do
  Nesstar::AtsidaIntegration.run
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

task :sample_study => :environment do
  archive_study_integration = ArchiveStudyIntegration.create!(:ddi_id => "00103", :archive => Archive.international, :user_id => Inkling::User.first.id)
  puts "ArchiveStudyIntegration created between #{archive_study_integration.ddi_id} and the International archive. Run 'rake nesstar' to create and reference the study to the archive."
end

task :cruise => [:test_env, :bundler, :environment, "ada:rebuild", :spec]

task :test_env do
  ENV['RAILS_ENV'] = 'test'
end

task :bundler do
  system('bundle install')
end