require 'spec_helper'

describe ArchiveStudyIntegration, do
  
 it "after update callback should create an associated archive_study when a study is present" do
   # study = Study.new()
   # study.valid?.should == false
   # 
   # study.label = "test dataset"
   # study.valid?.should == true
   archive = Archive.make
   integration = ArchiveStudyIntegration.create!(:archive_id => archive.id, :ddi_id => "foo")
   integration.archive_study.should be_nil
   study = Study.create!(:label => "foo")
   integration.study = study
   integration.save!
   integration.reload
   integration.archive_study.should_not be_nil
 end
 
end
