require File.dirname(__FILE__) + '/acceptance_helper'

feature "serving out Archive Catalogs" do

  background do
    parent = ArchiveCatalog.make(:title => "this can be anything", :archive => Archive.ada)
    @foo_catalog = ArchiveCatalog.make(:title => "foo", :archive => Archive.ada, :parent => parent)
    ArchiveCatalogStudy.make(:archive_catalog => @foo_catalog)
    ArchiveCatalogStudy.make(:archive_catalog => @foo_catalog)
  end
  
  scenario "requesting /ada/browse/foo should show breadcrumbs Browsing ada/foo" do
    visit "/ada/browse/foo"
    page.should have_content "Browsing: /ada/foo"
    page.status_code.should == 200
  end
  
  scenario "requesting a catalog holding studies should render the studies in title view" do
    visit "/ada/browse/foo"
    for archive_catalog_study in @foo_catalog.archive_catalog_studies
      page.should have_content archive_catalog_study.archive_study.study.title
      page.should have_content archive_catalog_study.archive_study.study.ddi_id
    end
  end
end
