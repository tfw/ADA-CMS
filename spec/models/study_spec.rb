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
   shortened_label = study.friendly_label
   shortened_label.split(/\W/).size.should eql 9
 end
 
 it "should store dataset and dataset entries from a hash" do
   data = {:label => "foo", :about => "about stuff", :one => 1, :two => 2}
   Study.store_with_fields(data)
   
   study = Study.find_by_label(data[:label])
   entry1 = StudyField.find_by_key('one')
   entry2 = StudyField.find_by_key('two')
   
   study.should_not be_nil
   entry1.should_not be_nil
   entry2.should_not be_nil
 end
 
 specify "that for_archive(archive) returns a matching archive_study" do
   archive_study = ArchiveStudy.make
   archive = archive_study.archive
   study = archive_study.study
   [1..9].each {ArchiveStudy.make(:study => study)} #make loads of them with the same study
   
   study.for_archive(archive).should == archive_study
 end
 
 specify "Study.store_with_entries should use the RDF parser to capture essential values" do
   study_hash = Nesstar::RDF::Parser.parse(File.expand_path("../nesstar/rdf/00102-f-test.xml", File.dirname(__FILE__)))
   study = Study.store_with_fields(study_hash)
   study.abstract.should_not be_nil
 end
end
