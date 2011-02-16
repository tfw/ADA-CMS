require 'spec_helper'

describe ArchiveStudyIntegration, do
  
 it "after update callback should create an associated archive_study when a study is present" do
   # study = Study.new()
   # study.valid?.should == false
   # 
   # study.label = "test dataset"
   # study.valid?.should == true
   
   integration = ArchiveStudyIntegration.create!(:archive_id => Archive.make, :ddi_id => "foo")
   integration.archive_study.should be_nil
   study = Study.create!(:label => "foo")
   integration.study = study
   integration.save!
   integration.archive_study.should != nil
 end
 
end
