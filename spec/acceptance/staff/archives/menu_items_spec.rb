require File.dirname(__FILE__) + '/../../acceptance_helper'

feature "Managing menu items" do

  context "approver (administrator)" do  
    background do
      @admin = make_user(:administrator)
      sign_in(@admin)
    end
    
    after(:each) do
      sign_out
    end
    
    scenario "saving a page puts the menu_item in draft state, and so is invisible to public" do
      create_page(Archive.ada, "one", "sample content")
      cms_page = Page.find_by_title("one")
      cms_page.menu_item.draft?.should == true
      visit root_path
      page.should_not have_content("one")
    end    

    scenario "I can publish a link from draft mode (if I'm an approver)" do
      create_menu_item(Archive.ada , "test page", "sample content")
      menu_item = MenuItem.find_by_title("test page")
      visit edit_staff_archive_menu_item_path(menu_item.archive, menu_item)
      page.should have_content("This link is waiting for publishing approval.")
      click_link("Approve?")      
      menu_item = MenuItem.find_by_title("test page")
      menu_item.state.should == Workflowable::PUBLISH
    end
  end
end
