require 'spec_helper'

describe Study, "The local respresentation of an ASSDA study" do
  
 it "should validate the presence of a name" do
   study = Study.new()
   study.valid?.should == false
   
   study.label = "test dataset"
   study.valid?.should == true
 end
 
 it "should offer an abbreviated form of the label" do
   study = Study.make(:label => " 1 2 3 4 5 6 7 8")
   puts study.label
   shortened_label = study.friendly_label
   shortened_label.split(/\W/).size.should eql 9
 end
 
 it "should store dataset and dataset entries from a hash" do
   data = {:label => "foo", :about => "about stuff", :one => 1, :two => 2}
   Study.store_with_entries(data)
   
   study = Study.find_by_label(data[:label])
   entry1 = StudyField.find_by_key('one')
   entry2 = StudyField.find_by_key('two')
   
   study.should_not be_nil
   entry1.should_not be_nil
   entry2.should_not be_nil
 end
end
