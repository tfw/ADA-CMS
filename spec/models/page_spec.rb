require 'spec_helper'

describe Page do

  describe "validations" do
    context "archive and page names" do
      it "saves pages with unique archive and page name combos" do
        page = Page.make
        page.errors.size.should == 0
      end
    end

    it "rejects colliding archive and page name combo duplications" do
      page = Page.make
      page.errors.any?.should == false
    
      page2 = Page.new(:archive => page.archive, :name => page.name, :author => page.author)
      page2.valid?.should == false
      page2.errors.any?.should == true
    end
  end
  
  describe "parent and child pages" do
    specify "parents know about children, children know about parents" do
      parent = Page.make
      child = Page.make(:parent => parent)
      parent.children.size.should == 1
      parent.children.first.should == child
      child.parent.should == parent
    end
  end
end
