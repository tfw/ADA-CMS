require File.dirname(__FILE__) + '/acceptance_helper'

feature "Cms Dashboard", %q{
  In order to use the cms dashboard
  As an admin/manager/approver/archivist
  I want to login
} do

  background do
    @admin = login_admin #creates an admin to login with
  end
  
  scenario "login should go to dashboard" do
    visit '/login'
    fill_in('inkling_user_email', :with => @admin.email)
    fill_in('inkling_user_password', :with => 'test123')
    click_button('Sign in')
    page.should have_content('Administration')
  end
end
