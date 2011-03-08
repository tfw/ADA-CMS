source 'http://rubygems.org'
source :gemcutter

gem 'rails', '3.0.5'

gem "pg"

gem 'inkling', :git => "git://github.com/tfw/inkling.git"

gem "devise", ">= 1.1.3"
gem 'inherited_resources'
gem 'cancan'
gem 'formtastic', '>= 1.1.0'
gem 'ckeditor' , :git => 'git://github.com/galetahub/rails-ckeditor.git', :branch => 'rails3'
gem 'ruote'
gem 'yajl-ruby'
gem 'yaml_db'
gem 'nokogiri'
gem 'jquery-rails', '>= 0.2.6' 
gem 'capistrano-ext'
gem 'thinking-sphinx', '>= 2.0.0', :require => 'thinking_sphinx'

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

# gems required for Microsoft SQL (where Clifford creates the schema diagrams)
#group :mssql do
#	gem 'activerecord-sqlserver-adapter'
#	gem 'tiny_tds'
#end
