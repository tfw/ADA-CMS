require File.dirname(__FILE__) + '/acceptance_helper'

feature "serving out CMS pages" do
  
<<<<<<< HEAD
  scenario "requesting / should map to /ada/home" do
=======
  scenario "requesting / should map to /ada_home" do
>>>>>>> parent of e26fbda... repairing test data - we create the ada home page in test data, everything is generated as needed by factories
    visit "/"
    page.status_code.should == 200
  end
end
