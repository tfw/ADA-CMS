require File.dirname(__FILE__) + '/../acceptance_helper'

feature "Cms Dashboard", %q{
  In order to use the cms dashboard
  As an admin/manager/approver/archivist
  I want to login
} do

  background do
    @admin = make_user(:administrator)
  end
  
  scenario "login should go to dashboard" do
    sign_in(@admin)
    visit('/staff/home')
puts page.body
    page.should have_content('Content to Publish')
    sign_out
  end
end
