require File.dirname(__FILE__) + '/acceptance_helper'

feature "serving out Archive Catalogs" do


  
  scenario "requesting / should map to /ada/home" do
    visit "/"
    page.status_code.should == 200
  end
end
