require File.dirname(__FILE__) + "/../spec_helper"
require "steak"
require 'capybara/rails'

RSpec.configuration.include Capybara, :type => :acceptance

# Put your acceptance spec helpers inside /spec/acceptance/support
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

def login(user)
  visit '/login'
  fill_in('inkling_user_email', :with => user.email)
  fill_in('inkling_user_password', :with => 'test123')
  click_button('Sign in')
end
