require File.dirname(__FILE__) + '/../acceptance_helper'

feature "Creating pages" do

  background do
    @admin = make_user(:administrator)
    sign_in(@admin)
    
  end
  # 
  # scenario "I can access the archive page form"  do
  #   visit_archive("historical")
  #   click_link("Add a page")
  #   page.should have_content("Historical - New Page")  
  # end
  # 
  scenario "I can create a page" do
    visit_archive("historical")
    click_link("Add a page")
    fill_in("page_title", :with => "test page")
    fill_in("page_body_editor", :with => "sample content .... ")
    click_button("Create Page")
    debugger
    page.should have_content("ARCHIVES: HISTORICAL")
    page.should have_content("test page")
  end
  
end
