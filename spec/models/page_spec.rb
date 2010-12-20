require 'spec_helper'
include Inkling::Slugs

describe Page do

  describe "validations" do
    context "archive and page names" do
      it "saves pages with unique archive and page name combos" do
        debugger
        page = Page.make
        page.errors.size.should == 0
      end
    end
  
    # it "rejects colliding archive and page name combo duplications" do
    #   page = Page.make
    #   page.errors.any?.should == false
    # 
    #   page2 = Page.new(:archive => page.archive, :title => page.title, :author => page.author)
    #   page2.valid?.should == false
    #   page2.errors.any?.should == true
    # end
  end
  # 
  # describe "parent and child pages" do
  #   specify "parents know about children, children know about parents" do
  #     parent = Page.make
  #     child = Page.make(:parent => parent)
  #     parent.children.size.should == 1
  #     parent.children.first.should == child
  #     child.parent.should == parent
  #   end
  # end
  # 
  # describe "belonging to an archive" do
  #   specify "pages which belong to archives take the archive name as a prefix, e.g. social-science/home" do
  #     parent = Page.make
  #     parent.path.slug.should == "/#{parent.archive.slug}/#{sluggerize(parent.title)}"
  #   end
  # end
  # 
  # describe "working with awesome nested set" do
  #   context "presenting root pages in the archive" do
  #     specify "calling Page.archive_roots calls Page.roots and sorts by page's archive" do
  #       page1 = Page.make
  #       page2 = Page.make(:archive => page1.archive)
  #       page3 = Page.make(:archive => page1.archive)
  #       page4 = Page.make
  #       
  #       Page.roots.size.should == 4
  #       Page.archive_roots(page1.archive).size.should == 3        
  #     end
  #     
  #     specify "an archive of nil returns pages for ADA" do
  #       page1 = Page.make(:archive => nil)
  #       page2 = Page.make(:archive => nil)
  #       page3 = Page.make(:archive => nil)
  #       page4 = Page.make
  #       
  #       Page.roots.size.should == 4
  #       Page.archive_roots(nil).size.should == 3        
  #     end
  #     
  #   end
  # end
end
