require File.dirname(__FILE__) + '/acceptance_helper'

feature "serving out CMS pages" do
  
  scenario "requesting / should map to /ada_home" do
    visit "/"
    page.status_code.should == 200
  end
end
