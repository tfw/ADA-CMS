require 'capistrano/ext/multistage'

set :application, "Australian Data Archives Website"
set :repository,  "git@adar.unfuddle.com:adar/ada.git"

set :scm, :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`
set :deploy_via, :remote_cache

role :web, "your web-server here"                          # Your HTTP server, Apache/etc
role :app, "your app-server here"                          # This may be the same as your `Web` server
role :db,  "your primary db-server here", :primary => true # This is where Rails migrations will run
role :db,  "your slave db-server here"

set :user,        "deploy"
set :use_sudo,    true
set :deploy_to,   "data"

ssh_options[:paranoid] = false
ssh_options[:port] = 22
ssh_options[:forward_agent] = true

set :branch, "master"


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