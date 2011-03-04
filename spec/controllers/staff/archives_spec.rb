require 'spec_helper'

describe Staff::ArchivesController do

  before(:each) do
    @admin = make_user(:administrator)
    sign_in @admin
  end 
  
  describe "urls via slugs" do
    context "backend access for each of 6 archives" do
      specify "that the name of the archive is sluggerized and the controller recognizes it for :show" do
        archive = Archive.make
    
        get :show, :id => archive.slug
        response.code.should == "200"
        assigns[:archive].should == archive
      end
    end
  end
  
  describe "updating page order" do
    context "with an ajax call" do
      specify "the moved page updates its siblings" do
        page = Page.make
        left = Page.make
        right = Page.make
        left.move_to_left_of page
        page.move_to_right_of left
        right.move_to_right_of page
        page.move_to_left_of right
        page.right_sibling.should == right
        page.left_sibling.should == left        
        page_order = "#{page.id}, #{left.id}, #{right.id}"
        post :update_page_order, {:page_order => page_order, :moved => "page-options-#{page.id}", :archive => nil}
        page.reload
        page.right_sibling.should == left
        page.left_sibling.should == nil
      end
    end
  end
end
