require 'spec_helper'

describe Variable, "The local respresentation of a variable for a study" do
  
 specify "Variable.stores should use the RDF parser to capture essential values" do
   study = Study.make(:about => "http://palo.anu.edu.au:80/obj/fStudy/au.edu.anu.assda.ddi.00401")
   vars = Nesstar::RDF::Parser.parse_variables(File.expand_path("../nesstar/rdf/00401@variables.xml", File.dirname(__FILE__)))

   i = 0

   for vars_hash in vars
     variable = Variable.store_with_fields(vars_hash)
     variable.label.should_not be_nil
     variable.study.should_not be_nil
   end
   
   vars.size.should == Variable.all.size
 end
end
