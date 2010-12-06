require File.dirname(__FILE__) + '/../../spec_helper'

describe Nesstar::RDF::Parser do

  it "should be able to load and convert a rdf Study to a hash" do
    Study_hash = Nesstar::RDF::Parser.parse(File.expand_path("00102-f-test.xml", File.dirname(__FILE__)))
    Study_hash.should_not be_nil

    Study_hash[:label].should eql "Aboriginal survey, New South Wales and South Australia, 1965: File f"
    Study_hash[:creationDate].should eql "2009-04-02 10:35:46.0"
  end

  it "should be a rdf hash into a Study with entries" do
    Study_hash = Nesstar::RDF::Parser.parse(File.expand_path("00102-f-test.xml", File.dirname(__FILE__)))
    Study = Study.store_with_entries(Study_hash)
    Study.should_not be_nil
    Study.entries.should_not be_nil
    Study.entries.find_by_key_and_Study_id("dataKind", Study.id).value.should eql "survey"
  end

  # <n34:relatedMaterials r:resource="http://bonus.anu.edu.au:80/obj/fStudy/au.edu.anu.assda.ddi.00102-f@relatedMaterials" />
  it "should convert attribute values into hash keys which build upon the owning element" do
    Study_hash = Nesstar::RDF::Parser.parse(File.expand_path("00102-f-test.xml", File.dirname(__FILE__)))
    Study_hash[:relatedMaterials_attribute_resource].any?.should be_true
    Study_hash[:relatedMaterials_attribute_resource].should eql 'http://bonus.anu.edu.au:80/obj/fStudy/au.edu.anu.assda.ddi.00102-f@relatedMaterials'
  end

  it "should have a Study AR model which returns the correct value for related_materials_attribute_resource" do
    Study_hash = Nesstar::RDF::Parser.parse(File.expand_path("00102-f-test.xml", File.dirname(__FILE__)))
    Study_hash[:relatedMaterials_attribute_resource].should eql 'http://bonus.anu.edu.au:80/obj/fStudy/au.edu.anu.assda.ddi.00102-f@relatedMaterials'
    Study = Study.store_with_entries(Study_hash)
    Study.related_materials_attribute.value.should eql Study_hash[:relatedMaterials_attribute_resource]
  end

  it "should parse attribute values properly" do
    Study_hash = Nesstar::RDF::Parser.parse(File.expand_path("00102-f-test.xml", File.dirname(__FILE__)))
    Study = Study.store_with_entries(Study_hash)
    Study.about.should eql "http://bonus.anu.edu.au:80/obj/fStudy/au.edu.anu.assda.ddi.00102-f"
  end

end
