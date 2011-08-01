require 'bundler/capistrano'
require 'capistrano/ext/multistage'

set :application, "Australian Data Archives Website"
set :repository,  'git@github.com:ANUSF/ADA-CMS.git'

set :scm, :git
set :deploy_via, :remote_cache

# role :web, "ada"                          # Your HTTP server, Apache/etc
# role :app, "ada"                          # This may be the same as your `Web` server
# role :db,  "ada", :primary => true # This is where Rails migrations will run

set :user,        "deploy"
# set :use_sudo,    true  #let's see how far we can get without this
set :deploy_to,   "/data"

default_run_options[:pty] = true
default_run_options[:tty] = true

ssh_options[:paranoid] = false
ssh_options[:port] = 22
ssh_options[:forward_agent] = true
ssh_options[:compression] = false

# set :branch, "master"

# The restart procedure for Passenger
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

set(:branch) do
  Capistrano::CLI.ui.ask "Open the hatch door please HAL: (specify a tag name to deploy):"
end

after 'deploy:setup', :create_extra_dirs
after 'deploy:setup', :copy_secrets

before 'deploy:update_code', :echo_ruby_env

after 'deploy:update', :symlinks
after 'deploy:update', :deploy_log
after 'deploy:update', :refresh_theme

desc "create additional shared directories during setup"
task :create_extra_dirs, :roles => :app do
  run "mkdir -p #{shared_path}/inkling"
  run "mkdir -p #{shared_path}/solr/data"
end

desc "copy the secret configuration file to the server"
task :copy_secrets, :roles => :app do
  prompt = "Specify a secrets.rb file to copy to the server:"
  path = Capistrano::CLI.ui.ask prompt
  put File.read("#{path}"), "#{shared_path}/secrets.rb", :mode => 0600
end

task :echo_ruby_env do
  puts "Checking ruby env ..."
  run "ruby -v"
  run "export RAILS_ENV='#{rails_env}'"
end

task :symlinks, :roles => :app do
  run "ln -nfs #{shared_path}/inkling #{current_path}/tmp/"
  run "ln -nfs #{shared_path}/solr/data #{current_path}/solr/"  
  run "ln -nfs #{shared_path}/secrets.rb #{current_path}/config/initializers"
  run "cd #{current_path}/config; ln -nfs database-deploy.yml database.yml"
end

task :deploy_log, :roles => :app do
  run "touch #{current_path}/tmp/deploy-log.txt"
  run "echo \"Deployed #{branch} at #{Time.now.strftime('%Y-%m-%d %I:%M')}\" > #{current_path}/tmp/deploy-log.txt"
end

task :refresh_theme, :roles => :app do
  run "cd #{current_path}; bundle exec rake RAILS_ENV=#{rails_env} install_theme"
end

namespace :solr do
  task :start do
    run "cd #{current_path}; bundle exec rake RAILS_ENV=#{rails_env} sunspot:solr:start"
  end
  task :stop do
    run "cd #{current_path}; bundle exec rake RAILS_ENV=#{rails_env} sunspot:solr:stop"
  end
  task :reindex do
    run "cd #{current_path}; bundle exec rake RAILS_ENV=#{rails_env} sunspot:reindex"
  end
end

namespace :apache do
  task :start do
    sudo "/etc/init.d/httpd start"
  end
  task :stop do
    sudo "/etc/init.d/httpd stop"
  end
  task :restart do
    sudo "/etc/init.d/httpd restart"
  end
end

namespace :db do
  namespace :clonefrom do
    dump = "pg_dump -Ft -b -U d10web --host pdb2.anu.edu.au -p 5432"
    restore = "pg_restore -O -U d10web --host pdb2.anu.edu.au -p 5432"

    task :staff do
      filename = "tmp/adacms_staff.tar"
      system "#{dump} adacms_staff > #{filename}"
      Rake::Task["apache:stop"].execute
      system "#{restore} -d adacms_#{rails_env} #{filename}"
      Rake::Task["apache:start"].execute
    end
  end
end
