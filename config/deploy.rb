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

# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end

# set(:branch) do
#   Capistrano::CLI.ui.ask "Open the hatch door please HAL: (specify a tag name to deploy):"
# end

namespace :bundler do
  task :create_symlink, :roles => :app do
    shared_dir = File.join(shared_path, 'bundle')
    release_dir = File.join(current_release, '.bundle')
    run("mkdir -p #{shared_dir} && ln -s #{shared_dir} #{release_dir}")
  end
 
  task :bundle_new_release, :roles => :app do
    bundler.create_symlink
    run "cd #{release_path} && bundle install --without test"
  end
end
 
after 'deploy:update_code', 'bundler:bundle_new_release'
before 'deploy:update_code', :echo_ruby_version

task :echo_ruby_version do
  puts "Checking ruby version ..."
  run "ruby -v"
end