require 'spec_helper'

describe MenuItem do

  describe "class methods for CRUD lifecycle matches on content callbacks" do
    context "pages" do
      it "can create an instance when passed a new page" do 
        page = Page.make
        menu_item = MenuItem.create_from_page(page)
        menu_item.valid?.should be_true
      end
      
      it "ensures that parent a menu item exists for the parent of the page it's handed" do
        parent_page = Page.make
        page = Page.make(:parent => parent_page)
        menu_item = MenuItem.create_from_page(page)
        menu_item.valid?.should be_false        
      end
    end
  end
end