require File.dirname(__FILE__) + '/acceptance_helper'

feature "serving out CMS pages" do
  
  scenario "requesting / should map to /ada/home" do
    # debugger
    visit "/"
    page.status_code.should == 200
  end
end
