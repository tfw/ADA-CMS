source 'http://rubygems.org'
source :gemcutter

gem 'rails', '3.0.6'

gem "pg"

gem 'inkling', :git => "git://github.com/tfw/inkling.git", :ref => "14498f1ada715c36ed92107ff126f484d91fe093" #, :path =>  "/Users/nicholas/code/src/tfw/inkling-project/inkling" # 

gem "devise", ">= 1.2.0"
gem 'devise_openid_authenticatable'

# if ENV['GEMS_LOCAL'] and File.exist? ENV['GEMS_LOCAL']
#   gem 'openid_client', :path => "#{ENV['GEMS_LOCAL']}/openid_client"
# else
  gem 'openid_client', :git => 'git://github.com/ANUSF/OpenID-Client-Engine.git'
# end

gem 'inherited_resources'
gem 'cancan'
gem 'formtastic', '>= 1.1.0'
gem 'ckeditor' , :git => 'git://github.com/cjheath/rails-ckeditor.git', :branch => 'rails3'
gem 'ruote', '2.1.11'
gem 'yajl-ruby'
gem 'yaml_db'
gem 'nokogiri'
gem 'jquery-rails', '>= 0.2.6' 
gem 'capistrano-ext'
gem 'thinking-sphinx', '>= 2.0.0', :require => 'thinking_sphinx'
gem 'will_paginate', ">=3.0pre"
gem 'paperclip', "~>2.3"
gem 'ratom'
gem 'sunspot_rails', '>=1.2.1'
gem 'mongrel', '~> 1.2.0.pre2'

# gem "ruby-debug19" #move this into dev group alone later

group :development, :test do
	gem "ruby-debug19"
	gem "rspec-rails", ">= 2.5.0"
	gem "rspec-core", ">= 2.5.0"
	gem 'capybara'
	gem 'spork'
	gem 'launchy'    # So you can do Then show me the page
	gem 'jeweler'
	gem 'gemcutter', '>= 0.6.1'
	gem "autotest"
	gem 'steak', '>= 1.0.0.rc.1'
	gem 'faker', '>=0.9.5'
 	gem 'machinist' , '>= 1.0.6'
	gem 'database_cleaner'
	gem 'capistrano'
end
