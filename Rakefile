# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
require 'rake'

Ada::Application.load_tasks

namespace :ada do
  task :rebuild => ["db:migrate:reset", "inkling:init", "db:seed"]
end

#override inkling's task so it uses login as identifier instead of email
# namespace :inkling do
#   desc "Create a default user with login 'admin' and password 'admin'"
#   task :default_admin => [:environment] do
#     user = Inkling::User.create!(:login => "admin", :password => "test123", :password_confirmation => "test123")
#     Inkling::RoleMembership.create!(:user => user, :role => Inkling::Role.find_by_name(Inkling::Role::ADMIN))
#     puts "Inkling> Created default administrator: login - 'admin@localhost.com', password - 'test123'."
#   end
# end

task :datasets => :environment do
  Nesstar::AtsidaIntegration.run
end