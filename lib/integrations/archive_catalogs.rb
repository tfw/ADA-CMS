class Integrations::ArchiveCatalogs
  
  def self.create_or_update(statement, archive_id) 
    statement_hash = statement.attributes
    parent = ArchiveCatalog.find_by_title(statement_hash["subjectId"])
    archive = Archive.find(archive_id)

    if statement_hash["objectType"] == "fCatalog"
      archive_catalog = ArchiveCatalog.create_or_update_from_nesstar(statement_hash, archive, parent)
    elsif statement_hash["objectType"] == "fStudy"
      study = Study.create_or_update_from_nesstar(statement_hash)
      # archive_study = ArchiveStudy.create_or_update_from_nesstar(study, archive)
      # archive_catalog_study = ArchiveCatalogStudy.create_or_update_from_nesstar(parent, study)
      puts "create a study - #{object_id}"
      puts "create an archive_study"
      puts "create an archive_catalog_study"      
    end
    
    puts " --- #{object_id} ---"
    # children = Nesstar::StatementEJB.find_all_by_subjectId(statement.objectId).collect {|s| s.objectId}
    # puts children.join " "
    Nesstar::StatementEJB.find_all_by_subjectId(statement.objectId).each {|s| create_or_update(s, archive_id)}
  end
end