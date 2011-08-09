require 'spec_helper'

describe Staff::ArchivesController do

  before(:each) do
    @admin = make_user(:administrator)
    sign_in @admin
    session[:openid_checked] = true
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
  
  # describe "updating menu order" do
  #   context "with an ajax post" do
  #     specify "the moved menu_item updates its siblings" do
  #       menu_item = MenuItem.make
  #       left = MenuItem.make
  #       right = MenuItem.make
  #       left.move_to_left_of menu_item
  #       menu_item.move_to_right_of left
  #       right.move_to_right_of menu_item
  #       menu_item.move_to_left_of right
  #       menu_item.right_sibling.should == right
  #       menu_item.left_sibling.should == left        
  #       menu_item_order = "#{menu_item.id}, #{left.id}, #{right.id}"
  #       post :update_menu_order, {:menu_order => menu_item_order, :moved => "menu-options-#{menu_item.id}", :archive => nil}
  #       menu_item.reload
  #       menu_item.right_sibling.should == left
  #       menu_item.left_sibling.should == nil
  #     end
  #   end
  # end
end
