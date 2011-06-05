require File.dirname(__FILE__) + '/acceptance_helper'

feature "serving out Archive Catalogs" do

  background do
    ArchiveCatalog.make(:title => )
  end
  
  scenario "requesting / should map to /ada/browse" do
    visit "/"
    page.status_code.should == 200
  end
end
