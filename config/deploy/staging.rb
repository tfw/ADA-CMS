set :application, "staging"

role :web, "ada"                          # Your HTTP server, Apache/etc
role :app, "ada"                          # This may be the same as your `Web` server
role :db,  "ada", :primary => true # This is where Rails migrations will run

set :rails_env, "production"

set :deploy_to,   "/data/"

set :user,        "deploy"
set :use_sudo,    true
set :deploy_to,   "/data"
