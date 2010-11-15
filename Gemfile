source 'http://rubygems.org'
source :gemcutter

gem 'rails', '3.0.0'

gem "pg"
gem "devise", :git => "git://github.com/plataformatec/devise.git" 
gem 'inherited_resources'
gem 'cancan'
gem 'formtastic', '>= 1.1.0'
gem 'ckeditor', :git => 'git://github.com/galetahub/rails-ckeditor.git', :branch => 'rails3'

group :development, :test do
	gem "ruby-debug19"
	gem "rspec-rails", ">= 2.0.0.beta.8", :group => [:test, :development]
	gem 'capybara'
	gem 'cucumber-rails'
	gem 'cucumber', '>= 0.7.2'
	gem 'spork'
	gem 'launchy'    # So you can do Then show me the page
	gem 'jeweler'
	gem 'gemcutter', '>= 0.6.1'
	gem "autotest"
	gem 'steak', '>= 1.0.0.rc.1'
	gem 'faker'
 	gem 'machinist' , '= 1.0.6'
	gem 'database_cleaner'
	gem 'capistrano'
	
	if ENV['RAILS_ENV'] != "staging"  #a necessary workaround to a bundler limitation: 
																		#see http://www.cowboycoded.com/2010/08/10/using-2-sources-for-a-gem-in-different-environments-with-bundler/
			gem 'inkling' # :git => "git://github.com/biv/inkling.git" 
	end
end

if ENV['RAILS_ENV'] == "staging"
	group :staging do
		gem 'inkling', :path => '/home/deploy/inkling'
	end
end