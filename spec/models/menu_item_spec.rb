require 'spec_helper'

describe MenuItem do

  describe "class methods for CRUD lifecycle matches on content callbacks" do
    context "pages" do
      it "can create an instance when passed a new page" do 
        page = Page.make
        menu_item = MenuItem.create_from_page(page)
        menu_item.valid?.should be_true
      end
    end
  end
end