require File.dirname(__FILE__) + '/../../acceptance_helper'

feature "Creating pages" do

  background do
    @admin = make_user(:administrator)
    sign_in(@admin)
  end
  
  after(:each) do
    sign_out
  end
  
  scenario "I can access the archive page form"  do
    visit_archive("historical")
    
    within(:xpath, "//fieldset[@id='menu-management']") do
      click_link("new-page-link")
    end
    
    page.should have_content("New Page: Historical")  
  end
  
  scenario "I can create a page" do
    create_page(Archive.historical, "test page", "sample content")
    page.should have_content("Archives: Historical")
    page.should have_content("test page")
  end
  
  # scenario "AJAX - the path displays after a title update of a page" do
  #   visit_archive("historical")
  #   click_link("Add a page")
  #   fill_in("page_title", :with => "test 1 2 3")
  #  
  #   within(:xpath, "//input[@id='page_path']") do
  #     debugger
  #     page.should have_content('test-1-2-3')
  #   end
  # end
  
  # scenario "I can preview a page before it is created in the db" do
  #   visit_archive("historical")
  #   click_link("Add a page")
  #   fill_in("page_title", :with => "testing 1 2 3")
  #   fill_in("page_body_editor", :with => "some text about stuff and stuff")
  #   click_link("Preview")
  #   
  #     within(:xpath, "//div[@id='preview']") do
  #       puts page.body
  #       page.should have_content('testing 1 2 3')
  #       page.should have_content('some text about stuff and stuff')
  #     end    
  # end
end
