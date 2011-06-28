# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
require 'rake'
require 'thinking_sphinx/tasks'

Ada::Application.load_tasks

namespace :ada do
  task :rebuild => ["db:drop", "db:create", "db:migrate", "db:bootstrap", "db:seed", "install_theme"]
end

task :restore_postgres do
  system("psql -d ada_#{Rails.env} < ada_data_13_2_2011.out")
end

task :install_theme => :environment do
  Inkling::Theme.install_from_dir("config/theme")
end

#tasks necessary for cruisecontrolrb
task :cruise => [:test_env, :bundler, :environment, "ada:rebuild", :spec]

task :test_env do
  ENV['RAILS_ENV'] = 'test'
end

task :bundler do
  system('bundle install')
end

task :regenerate_paths => :environment do
  for klass in [Page, News, ArchiveStudy, Document, Image, ArchiveCatalog, Inkling::Feed]
    klass.all.each do |content| 
      content.save! 
      puts "#{klass.to_s}-(title #{content.title}): #{content.path.slug}"
    end
  end
end

task :create_feeds => :environment do
  for archive in Archive.all
    Inkling::Feed.create!(:title => "#{archive.name} Atom Feed", :format => "Inkling::Feeds::Atom", :source => "NewsFeedsSource", :authors => archive.name, :criteria => {:archive_id => archive.id})    
  end
end

task :integrate => :environment do
  require 'ruby-debug'
  Integrations::ArchiveCatalogs.create_or_update(Nesstar::StatementEJB.find_by_objectId("indigenous"), Archive.indigenous.id)
  Integrations::ArchiveCatalogs.create_or_update(Nesstar::StatementEJB.find_by_objectId("social-science"), Archive.social_science.id)
  Integrations::ArchiveCatalogs.create_or_update(Nesstar::StatementEJB.find_by_objectId("historical"), Archive.historical.id)
  Integrations::ArchiveCatalogs.create_or_update(Nesstar::StatementEJB.find_by_objectId("longitudinal"), Archive.longitudinal.id)
  Integrations::ArchiveCatalogs.create_or_update(Nesstar::StatementEJB.find_by_objectId("qualitative"), Archive.qualitative.id)
  Integrations::ArchiveCatalogs.create_or_update(Nesstar::StatementEJB.find_by_objectId("international"), Archive.international.id)
  Integrations::RelatedMaterials.create_or_update
  vars_in_archive(Archive.indigenous)
  vars_in_archive(Archive.qualitative)
  vars_in_archive(Archive.international)
  vars_in_archive(Archive.historical)
  vars_in_archive(Archive.social_science)
  vars_in_archive(Archive.longitudinal)
end

def vars_in_archive(archive)
  beginning = Time.now
  puts "Beginning #{archive.name} integration at #{Time.now}"
  Integrations::Variables.create_or_update(archive)
  puts Time.now
  diff = Time.now - beginning

  p diff  
end