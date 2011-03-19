require 'spec_helper'

describe StudyField do
  
 it "should validate the presence of a name" do
   study = Study.make()
   field = StudyField.create!(:key => "foo", :value => "hello", :study => study)
   fields = StudyField.to_hash(study)
   fields['foo'].should eql "hello"
 end
end
