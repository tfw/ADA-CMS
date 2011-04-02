require 'spec_helper'

describe Variable, "The local respresentation of a variable for a study" do
  
 specify "Variable.stores should use the RDF parser to capture essential values" do
   study = Study.make(:about => "http://palo.anu.edu.au:80/obj/fStudy/au.edu.anu.assda.ddi.01228")
   vars = Nesstar::RDF::Parser.parse_variables(File.expand_path("../nesstar/rdf/00401@variables.xml", File.dirname(__FILE__)))

   i = 0

   for vars_hash in vars
     variable = Variable.store_with_fields(vars_hash)
     variable.label.should_not be_nil
     variable.study.should_not be_nil
   end
      
   vars.size.should == Variable.all.size
 end
 
 specify "it sets the question_text when available" do
   study = Study.make(:about => "http://palo.anu.edu.au:80/obj/fStudy/au.edu.anu.assda.ddi.01228")
   vars = Nesstar::RDF::Parser.parse_variables(File.expand_path("../nesstar/rdf/00401@variables.xml", File.dirname(__FILE__)))

   i = 0

   for vars_hash in vars
     variable = Variable.store_with_fields(vars_hash)
   end   
   
   Variable.find_all_by_question_text.size.should > 0
 end
end
