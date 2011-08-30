require 'spec_helper'
require 'workflowable'

describe Workflowable do

  before(:each) {@workflowable = Page.make}

  specify "that it defaults to a value of draft" do
    @workflowable.draft?.should == true
  end

  specify "that after_save places it in draft" do
    @workflowable.draft?.should == true
    user = make_user(:administrator)
    @workflowable.save!
    @workflowable.draft?.should == true    
  end

  specify "that only permitted roles are allowed to put a worklowable into the published state" do
    ["administrator", "Manager", "Publisher", "Approver"].each do |role_name|
      @workflowable.draft?.should == true
      user = make_user(role_name)
      @workflowable.publish!(user)
      @workflowable.published?.should == true
      @workflowable.draft!
    end

    user = make_user("Archivist")
    @workflowable.publish!(user).should == false
  end
end
