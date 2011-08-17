require 'spec_helper'
require 'workflowable'

class Foo
  include Workflowable

  attr_accessor :state
end

describe Workflowable do

  before(:each) {@workflow_foo = Foo.new}

  specify "that it defaults to a value of draft" do
    @workflow_foo.draft?.should == Workflowable::DRAFT
  end
end
