require 'spec_helper'

describe Page do

  describe "validations" do
    context "given a unique archive and page name" do
      page = Page.make
      page.errors.size.should == 0
    end

    # context "given a colliding archive and page name" do
    #   page = Factory(:page, :archive => Archive::SOCIAL_SCIENCE)
    #   page.errors.should == 0
    # 
    #   page = Factory(:page, :archive => Archive::SOCIAL_SCIENCE)
    #   page.errors.should == 0
    # end
  end
end
