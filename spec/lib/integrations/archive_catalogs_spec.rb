require 'spec_helper'

describe Integrations::ArchiveCatalogs do

  specify "it converts a Nesstar::StatementEJB into an archive_catalog" do
    statement = Nesstar::StatementEJB.new
    archive = Archive.make
    Nesstar::StatementEJB.expects(:find_all_by_subjectId).with("indigenous").returns([])
    statement.expects(:attributes).returns(data)
    statement.expects(:objectId).returns("indigenous")  
    Integrations::ArchiveCatalogs.create_or_update(statement, archive)
    
    ArchiveCatalog.find_by_title("indigenous").should_not be_nil
    archive.reload
    archive.archive_catalogs.any?.should be_true
  end
  
  
  def data
    {"comment"=>nil,
      "objectId"=>"indigenous", "objectType"=>"fCatalog", "predicateIndex"=>3, "predicateType"=>"children", 
      "subjectId"=>"ADA", "subjectType"=>"fCatalog"} 
  end
end
