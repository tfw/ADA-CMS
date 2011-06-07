require File.dirname(__FILE__) + '/acceptance_helper'

feature "serving out Archive Catalogs" do

  background do
    parent = ArchiveCatalog.make(:title => "this can be anything", :archive => Archive.ada)
    ArchiveCatalog.make(:title => "foo", :archive => Archive.ada, :parent => parent)
  end
  
  scenario "requesting /ada/browse/foo should show breadcrumbs Browsing ada/foo" do
    visit "/ada/browse/foo"
    page.should have_content "Browsing: /ada/foo"
    page.status_code.should == 200
  end
end
