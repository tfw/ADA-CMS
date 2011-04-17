require File.dirname(__FILE__) + '/../../spec_helper'

describe Nesstar::RDF::Parser do

  it "should be able to load and convert a rdf Study to a hash" do
    study_hash = Nesstar::RDF::Parser.parse(File.expand_path("test-study.xml", File.dirname(__FILE__)))
    study_hash.should_not be_nil

    study_hash[:label].should eql "Tertiary education for rural and remote area health workers, 1992"
    study_hash[:creationDate].should eql "2011-04-11 10:25:52.0"
  end

  it "should be a rdf hash into a Study with entries" do
     study_hash = Nesstar::RDF::Parser.parse(File.expand_path("test-study.xml", File.dirname(__FILE__)))
     study = Study.store_with_fields(study_hash)
     study.should_not be_nil
     study.fields.should_not be_nil
     study.fields.find_by_key_and_study_id("dataKind", study.id).value.should eql "census data"
   end
   
   # <n34:relatedMaterials r:resource="http://bonus.anu.edu.au:80/obj/fStudy/au.edu.anu.assda.ddi.00102-f@relatedMaterials" />
   it "should convert attribute values into hash keys which build upon the owning element" do
     study_hash = Nesstar::RDF::Parser.parse(File.expand_path("test-study.xml", File.dirname(__FILE__)))
     (study_hash[:relatedMaterials_attribute_resource].size > 0).should be_true
     study_hash[:files_attribute_resource].should == 'http://bonus.anu.edu.au:81/obj/fStudy/au.edu.anu.ada.ddi.00625@files'
   end
   
   it "should have a Study AR model which returns the correct value for related_materials_attribute_resource" do
     study_hash = Nesstar::RDF::Parser.parse(File.expand_path("test-study.xml", File.dirname(__FILE__)))
     study_hash[:relatedMaterials_attribute_resource].should eql 'http://bonus.anu.edu.au:81/obj/fStudy/au.edu.anu.ada.ddi.00625@relatedMaterials'
     study = Study.store_with_fields(study_hash)
     study.related_materials_attribute.value.should == study_hash[:relatedMaterials_attribute_resource]
   end
   
   it "should parse attribute values properly" do
     study_hash = Nesstar::RDF::Parser.parse(File.expand_path("test-study.xml", File.dirname(__FILE__)))
     study = Study.store_with_fields(study_hash)
     study.about.should == "http://bonus.anu.edu.au:81/obj/fStudy/au.edu.anu.ada.ddi.00625"
   end
   
   it "should return dataKind in the study_hash" do
     study_hash = Nesstar::RDF::Parser.parse(File.expand_path("test-study.xml", File.dirname(__FILE__)))
     study_hash.should_not be_nil
  
     study_hash[:dataKind].should eql "census data"
     study_hash[:collMode].should eql "self-completion (mail out, mail back)\n\nuse of existing records\n\nA questionnaire was sent to educational institutions and relevant professional associations. The information obtained from the questionnaires was supplemented and validated by reference to institution calenders and handbooks, and the Directory of Tertiary External Courses in Australia."
     study_hash[:sampling].split(/\n/).first.should eql "no sampling (total universe)"
     study_hash[:abstractText].should_not be_nil
   end
   
   specify "that it scans and hasherizes variables documents" do
     vars = Nesstar::RDF::Parser.parse_variables(File.expand_path("test@variables.xml", File.dirname(__FILE__)))
     vars.should_not be_nil
     
     labels = []
  
     for var in vars
       labels << var[:label] unless var[:label].blank?
     end
     
     labels.size.should > 0
   end
end
