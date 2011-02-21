require File.dirname(__FILE__) + '/../../acceptance_helper'

feature "Accessing integrations" do

  background do
    @admin = make_user(:administrator)
    sign_in(@admin)
    @archive = Archive.make
  end
  
  after(:each) do
    sign_out
  end

  scenario "I can access the integrations page for an archive"  do
    visit_integrations(@archive)
  end  
end
