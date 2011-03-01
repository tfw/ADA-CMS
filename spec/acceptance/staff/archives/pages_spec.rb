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
    click_link("Add a page")
    page.should have_content("Pages: Historical New")  
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
end
