require File.dirname(__FILE__) + '/acceptance_helper'

feature "Cms Dashboard", %q{
  In order to use the cms dashboard
  As an admin/manager/approver/archivist
  I want to login
} do

  background do
    user = Inkling::User.create!(:email => "admin@localhost.com", :password => "test123", :password_confirmation => "test123")
    Inkling::RoleMembership.create!(:user => user, :role => Inkling::Role.find_by_name(Inkling::Role::ADMIN))
  end

  scenario "login should go to dashboard" do
  end
end
