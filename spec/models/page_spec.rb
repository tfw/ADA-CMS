require 'spec_helper'

describe Page do

  describe "validations" do
    # context "given a unique archive and page name" do
    #   page = Page.make
    #   page.errors.size.should == 0
    # end

    context "given a colliding archive and page name" do
      page = Page.make
      page.errors.any?.should == false
    
      page2 = Page.new(:archive => page.archive, :name => page.name, :author => page.author)
      page2.valid?.should == false
      page2.errors.any?.should == true
    end
  end
  
  # describe "parent and child pages" do
  #   
  # end
end
