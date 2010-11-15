# require 'capistrano/ext/multistage'
require 'bundler/capistrano'

set :application, "Australian Data Archives Website"
set :repository,  "git@adar.unfuddle.com:adar/ada.git"

set :scm, :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`
set :deploy_via, :remote_cache

role :web, "ada-staging"                          # Your HTTP server, Apache/etc
role :app, "ada-staging"                          # This may be the same as your `Web` server
role :db,  "ada-staging", :primary => true # This is where Rails migrations will run

set :user,        "deploy"
set :use_sudo,    true
set :deploy_to,   "/data"

default_run_options[:pty] = true
default_run_options[:tty] = true

ssh_options[:paranoid] = false
ssh_options[:port] = 22
ssh_options[:forward_agent] = true
ssh_options[:compression] = false

set :branch, "master"
set :rails_env, "staging"


# If you are using Passenger mod_rails uncomment this:
# if you're still using the script/reapear helper you will need
# these http://github.com/rails/irs_process_scripts

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

# set(:branch) do
#   Capistrano::CLI.ui.ask "Open the hatch door please HAL: (specify a tag name to deploy):"
# end


desc "generate a new database.yml"
task :generate_database_yml, :roles => :app do
  
  buffer = {"#{rails_env}" => {'database' => "ada_#{rails_env}", 'adapter' => 'postgresql', 'username' => 'postgres', :password => 'test123', :encoding => 'unicode'}}
  put YAML::dump(buffer), "#{current_path}/config/database.yml", :mode => 0664
end
#  
# after 'deploy:update_code', 'bundler:bundle_new_release'
after 'deploy:update', :generate_database_yml
before 'deploy:update_code', :echo_ruby_env

task :echo_ruby_env do
  puts "Checking ruby env ..."
  run "ruby -v"
  run "export RAILS_ENV='#{rails_env}'"
end

# development:
#   adapter: postgresql
#   encoding: unicode
#   database: ada_development
#   pool: 5