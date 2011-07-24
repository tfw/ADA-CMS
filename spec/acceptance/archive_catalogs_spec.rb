require File.dirname(__FILE__) + '/acceptance_helper'

feature "serving out Archive Catalogs" do

  background do
    parent = ArchiveCatalog.make(:label => "this can be anything", :archive => Archive.indigenous)
    @catalog = ArchiveCatalog.make(:label => "foo", :archive => Archive.indigenous, :parent => parent)
    archive_study1 = ArchiveStudy.make(:archive_id => @catalog.archive.id)
    archive_study2 = ArchiveStudy.make(:archive_id => @catalog.archive.id)
    archive_study3 = ArchiveStudy.make(:archive_id => @catalog.archive.id)
    ArchiveCatalogStudy.make(:archive_catalog => @catalog, :archive_study => archive_study1)
    ArchiveCatalogStudy.make(:archive_catalog => @catalog, :archive_study => archive_study2)
    @archive_catalog_study3 = ArchiveCatalogStudy.make(:archive_catalog => @catalog, :archive_study => archive_study3)
  end
  
  scenario "/browse returns a 200" do
    visit "/browse"
    page.status_code.should == 200
  end

  scenario "/ada/browse returns a 200" do
    visit "/ada/browse"
    page.status_code.should == 200
  end
  
  scenario "requesting /ada/browse/foo should show breadcrumbs Browsing ada/foo" do
    visit @catalog.urn
    page.should have_content "Browsing #{@catalog.path.slug.gsub('/browse', '')}"
    page.status_code.should == 200
  end
  
  scenario "requesting a catalog holding studies should render studies in title view" do
    visit @catalog.urn
    click_link 'foo'
  
    for archive_catalog_study in @catalog.archive_catalog_studies
      page.should have_content archive_catalog_study.study.ddi_id
    end
  end
  
  scenario "requesting a catalog with studies and clicking on Extended should show extended info" do
    visit @catalog.urn
    click_link 'Extended'
  
    for archive_catalog_study in @catalog.archive_catalog_studies
       page.should have_content archive_catalog_study.study.abstract_text.split(/\W/)[0..3].join " "
    end
  end
  
  scenario "selecting a study should render the entire catalog of studies, but the selected study is first in the table" do
    visit @catalog.urn
  
    within(:xpath, "//table[@id='browse-results-title']") do
    # within(:xpath, "//table[@id='browse-results-title']/tr[1]") do -- ideally we could specify the first tabe row, not xpath friendly
        page.should have_content(@archive_catalog_study3.study.ddi_id)
    end    
  end  
end
