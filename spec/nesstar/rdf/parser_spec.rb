require File.dirname(__FILE__) + '/../../spec_helper'

describe Nesstar::RDF::Parser do

  it "should be able to load and convert a rdf Study to a hash" do
    study_hash = Nesstar::RDF::Parser.parse(File.expand_path("00102-f-test.xml", File.dirname(__FILE__)))
    study_hash.should_not be_nil

    study_hash[:label].should eql "Aboriginal survey, New South Wales and South Australia, 1965: File f"
    study_hash[:creationDate].should eql "2009-04-02 10:35:46.0"
  end

  it "should be a rdf hash into a Study with entries" do
    study_hash = Nesstar::RDF::Parser.parse(File.expand_path("00102-f-test.xml", File.dirname(__FILE__)))
    study = Study.store_with_entries(study_hash)
    study.should_not be_nil
    study.fields.should_not be_nil
    study.fields.find_by_key_and_study_id("dataKind", study.id).value.should eql "survey"
  end
  
  # <n34:relatedMaterials r:resource="http://bonus.anu.edu.au:80/obj/fStudy/au.edu.anu.assda.ddi.00102-f@relatedMaterials" />
  it "should convert attribute values into hash keys which build upon the owning element" do
    study_hash = Nesstar::RDF::Parser.parse(File.expand_path("00102-f-test.xml", File.dirname(__FILE__)))
    (study_hash[:relatedMaterials_attribute_resource].size > 0).should be_true
    study_hash[:relatedMaterials_attribute_resource].should == 'http://bonus.anu.edu.au:80/obj/fStudy/au.edu.anu.assda.ddi.00102-f@relatedMaterials'
  end
  
  it "should have a Study AR model which returns the correct value for related_materials_attribute_resource" do
    study_hash = Nesstar::RDF::Parser.parse(File.expand_path("00102-f-test.xml", File.dirname(__FILE__)))
    study_hash[:relatedMaterials_attribute_resource].should eql 'http://bonus.anu.edu.au:80/obj/fStudy/au.edu.anu.assda.ddi.00102-f@relatedMaterials'
    study = Study.store_with_entries(study_hash)
    study.related_materials_attribute.value.should == study_hash[:relatedMaterials_attribute_resource]
  end
  
  it "should parse attribute values properly" do
    study_hash = Nesstar::RDF::Parser.parse(File.expand_path("00102-f-test.xml", File.dirname(__FILE__)))
    study = Study.store_with_entries(study_hash)
    study.about.should == "http://bonus.anu.edu.au:80/obj/fStudy/au.edu.anu.assda.ddi.00102-f"
  end
  
  it "should return dataKind in the study_hash" do
    study_hash = Nesstar::RDF::Parser.parse(File.expand_path("00102-f-test.xml", File.dirname(__FILE__)))
    study_hash.should_not be_nil

    study_hash[:dataKind].should eql "survey"
    study_hash[:collMode].should eql "personal interview"
    study_hash[:sampling].split(/\n/).first.should eql "non-probability sample"
    study_hash[:abstractText].should_not be_nil
  end
  
  specify "that it scans and hasherizes variables documents" do
    vars_hash = Nesstar::RDF::Parser.parse_variables(File.expand_path("00401@variables.xml", File.dirname(__FILE__)))
    vars_hash.should_not be_nil
  end
end
