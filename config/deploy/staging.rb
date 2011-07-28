$:.unshift(File.join(ENV['rvm_path'], 'lib'))
require 'rvm/capistrano'

set :rvm_ruby_string, 'ruby-1.9.2-p290'

role :web, "web5.nci.org.au"
role :app, "web5.nci.org.au"
role :db,  "web5.nci.org.au", :primary => true

set :user,        "d10web"
set :use_sudo,    false
set :deploy_to,   "/data/httpd/Rails/ADA-CMS"

# used by migrations:
set :rails_env, "staging"
