# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
require 'rake'
require 'thinking_sphinx/tasks'

Ada::Application.load_tasks

namespace :ada do
  task :rebuild => :environment do
    if ["development", "devs", "test", "staging"].include? Rails.env
      ["db:drop", "db:create", "db:migrate", "db:bootstrap", "db:seed", "install_theme"].each do |t|
        Rake::Task[t].execute
      end
    else
      puts "ada:rebuild isn't meant to run on staff, public, or any other production level environment."
    end
  end
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
  for klass in [Page, ArchiveNews, ArchiveStudy, Document, Image, ArchiveCatalog, Inkling::Feed]
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

task :ensure_menu_items => :environment do
  MenuItem.delete_all
  parent_pages = Page.find_all_by_parent_id(nil)
  parent_pages.each do |page|
    menu_items_for_tree(page)
  end
end

def menu_items_for_tree(page)
  MenuItem.create_from_page(page)
  
  for child in page.children
    menu_items_for_tree(child)
  end 
end





