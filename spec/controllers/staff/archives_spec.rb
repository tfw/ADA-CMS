require 'spec_helper'

describe Staff::ArchivesController do

  before(:each) do
    @admin = make_admin
    sign_in @admin
  end 
  
  describe "urls via slugs" do
    context "backend access for each of 6 archives" do
      specify "that the name of the archive is sluggerized and the controller recognizes it for :show" do
        archive = Archive.make
    
        get :show, :slug => archive.slug
        response.code.should == "200"
        assigns[:archive].should == archive
      end
    end
  end
end
