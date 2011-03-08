# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'ruby-debug'
require 'thinking_sphinx/test'

ThinkingSphinx::Test.init


# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

include Rails.application.routes.url_helpers

RSpec.configure do |config|
  # == Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  config.mock_with :rspec

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # config.before(:all)    { Sham.reset(:before_all)  }
  
  # config.before(:suite) do
  #   `rake RAILS_ENV=test thinking_sphinx:index`
  # end

  config.before(:each, :type => :acceptance) do
    Sham.reset(:before_each) 
    DatabaseCleaner.start
    ["administrator", "manager", "approver", "archivist", "member"].each do |role_name| 
      Inkling::Role.create!(:name => role_name) if Inkling::Role.find_by_name(role_name).nil?
    end    
    
    make_user(:administrator)
    
    ["ADA", "Social Science", "Historical", "Indigenous", "Longitudinal", "Qualitative", "International"].each do |archive_name|
      if Archive.find_by_name(archive_name).nil?
        archive = Archive.new(:name => archive_name)
        archive.save!
      
        Page.create!(:archive_id => archive.id, :title => "Home", :body => "", :author =>  Inkling::Role.find_by_name("administrator").users.first, :partial => "/pages/home_page") unless Page.find_by_title_and_archive_id("Home", archive.id)
      end
    end  

    # #install the content theme, as we have to test front end presentation
    theme = Inkling::Theme.install_from_dir("config/theme")
  end

  config.after(:each, :type => :acceptance) do
    DatabaseCleaner.clean
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  # config.before(:each, :type => :acceptance) do
  # end
  
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.after(:each) do
   Sham.reset
   DatabaseCleaner.clean
  end
  
  config.include Devise::TestHelpers, :type => :controller
end
