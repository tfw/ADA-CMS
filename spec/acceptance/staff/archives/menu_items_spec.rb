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
  end
end
