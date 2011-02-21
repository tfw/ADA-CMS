require File.dirname(__FILE__) + '/../acceptance_helper'

feature "Creating pages" do

  background do
    @admin = make_user(:administrator)
    sign_in(@admin)
  end
  
  scenario "I can access the archive page form"  do
    visit_archive("historical")
    click_link("Add a page")
    page.should have_content("Historical - New Page")  
  end
  
  scenario "I can create a page" do
    create_page(Archive.historical, "test page", "sample content")
    page.should have_content("Archives: Historical")
    page.should have_content("test page")
  end

end
