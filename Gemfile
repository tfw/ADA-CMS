source 'http://rubygems.org'
source :gemcutter

gem 'rails', '3.0.7'

gem "pg"
gem "mysql2"

gem 'inkling', :git => "git://github.com/tfw/inkling.git"  
#gem 'inkling', :path => "/Users/nicholas/code/src/tfw/inkling-project/inkling"

gem "devise", ">= 1.2.0"
gem 'devise_openid_authenticatable', '~> 1.0.0'

if ENV['GEMS_LOCAL'] and File.exist? ENV['GEMS_LOCAL']
  path = ENV['GEMS_LOCAL']
  gem 'openid_client', '~> 0.1.1', :path => "#{path}/openid_client"
else
  git = 'git://github.com/ANUSF'
  gem 'openid_client', '~> 0.1.1', :git => "#{git}/OpenID-Client-Engine.git"
end

gem 'inherited_resources'
gem 'cancan'
gem 'formtastic'
gem 'ckeditor' , :git => 'git://github.com/cjheath/rails-ckeditor.git', :branch => 'rails3'
gem 'ruote', :git => 'https://github.com/jmettraux/ruote.git' # '2.1.11'
# gem 'sourcify', :git => "https://github.com/ngty/sourcify.git"
gem 'yajl-ruby'
gem 'yaml_db'
gem 'nokogiri'
gem 'jquery-rails', '>= 0.2.6' 
gem 'capistrano-ext'
gem 'thinking-sphinx', '>= 2.0.0', :require => 'thinking_sphinx'
gem 'will_paginate', ">=3.0pre"
gem 'paperclip', ">=2.3"
gem 'ratom'
gem 'sunspot_rails', '>=1.2.1'
gem 'mongrel', '~> 1.2.0.pre2'
gem 'httparty'
gem 'delayed_job'

# gem "ruby-debug19" #move this into dev group alone later

group :development, :test do
	gem "ruby-debug19"
	gem "mocha"
	gem "rspec-rails", ">= 2.6.0"
	gem "rspec-core", ">= 2.6.0"
	gem 'capybara'
	gem 'gemcutter', '>= 0.6.1'
	gem "autotest"
	gem "database_cleaner"
	gem 'steak', '>= 1.0.0.rc.1'
	gem 'faker', '>=0.9.5'
 	gem 'machinist' , '>= 1.0.6'
	gem 'capistrano'
	gem 'selenium-webdriver', '>= 0.2.1'
  gem 'simplecov', '>= 0.4.0', :require => false, :group => :test
end
