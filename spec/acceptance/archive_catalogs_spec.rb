require File.dirname(__FILE__) + '/acceptance_helper'

feature "serving out Archive Catalogs" do

  background do
    parent = ArchiveCatalog.make(:title => "this can be anything", :archive => Archive.indigenous)
    @catalog = ArchiveCatalog.make(:title => "foo", :archive => Archive.indigenous, :parent => parent)
    archive_study1 = ArchiveStudy.make(:archive_id => @catalog.archive.id)
    archive_study2 = ArchiveStudy.make(:archive_id => @catalog.archive.id)
    ArchiveCatalogStudy.make(:archive_catalog => @catalog, :archive_study => archive_study1)
    ArchiveCatalogStudy.make(:archive_catalog => @catalog, :archive_study => archive_study2)
  end
  
  scenario "requesting /ada/browse/foo should show breadcrumbs Browsing ada/foo" do
    visit @catalog.path.slug
    page.should have_content "Browsing: #{@catalog.path.slug.gsub('/browse', '')}"
    page.status_code.should == 200
  end
  
  scenario "requesting a catalog holding studies should render studies in title view" do
    visit @catalog.path.slug

    click_link 'foo'

    for archive_catalog_study in @catalog.archive_catalog_studies
      page.should have_content archive_catalog_study.study.ddi_id
    end
  end
end
