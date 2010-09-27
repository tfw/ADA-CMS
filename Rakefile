# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
require 'rake'

Ada::Application.load_tasks


desc "Creates ADA configuration of Inkling"
task :init => :environment
#roles
  ["Manager", "Approver", "Archivist"].each do {|role_name| Inkling::Role.create!(:name => role_name)
#permissions
  
end