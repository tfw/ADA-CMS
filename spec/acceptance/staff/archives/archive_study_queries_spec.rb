require File.dirname(__FILE__) + '/../../acceptance_helper'

feature "Managing archive study queries" do

  background do
    @admin = make_user(:administrator)
    sign_in(@admin)
    @archive = Archive.make
  end
  
  after(:each) do
    sign_out
  end

  scenario "I can create a new archive study query for an archive"  do
    create_study_query(@archive, "query1", "some long query")
  end

  scenario "I can edit an archive study query for an archive"  do
    create_study_query(@archive, "query2", "foo bar")
    query = ArchiveStudyQuery.find_by_name("query2")
    visit edit_staff_archive_archive_study_query_path(@archive, query)
    fill_in("archive_study_query_name", :with => "query2")
    fill_in("archive_study_query_query", :with => "foo bar updated")
    click_button("Update Archive study query")
    page.should have_content("query2")    
  end
  
  #capybara can't http delete - rack-test can, look into this later.
  
  
  def create_study_query(archive, name, query)
    visit new_staff_archive_archive_study_query_path(archive)
    page.should have_content("Return to Integrations")
    fill_in("archive_study_query_name", :with => name)
    fill_in("archive_study_query_query", :with => query)
    click_button("Create Archive study query")
    page.should have_content(name)
  end
  
end
