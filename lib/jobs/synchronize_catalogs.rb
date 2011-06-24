#objectId is the name of the catalog
#subjectId is the name of the parent

#in the below, some objectIds are repeated across catalogs, though not the signficant ones (like a subarchive title)
#so, we have to locate catalogs by their Nesstar ids, but begin synchronization using a objectIds, as we begin at the subarchive level

class Jobs::SynchronizeCatalogs < Struct.new(:object_id, :archive_id)

  def perform
    statement = Nesstar::StatementEJB.find_by_objectId(object_id)
    create_or_update_catalog(statement.id, archive_id)
  end
  
  def create_or_update_catalog(id, archive_id) 
    statement = Nesstar::StatementEJB.find(id)
    statement_hash = statement.attributes
    parent = ArchiveCatalog.find_by_title(statement_hash["subjectId"])
    archive = Archive.find(archive_id)

    if statement_hash["objectType"] == "fCatalog"
      archive_catalog = ArchiveCatalog.create_or_update_from_nesstar(statement_hash, archive, parent)
    elsif statement_hash["objectType"] == "fStudy"
      puts "create a study - #{object_id}"
      puts "create an archive_study"
      puts "create an archive_catalog_study"      
    end
    
    puts " --- #{object_id} ---"
    children = Nesstar::StatementEJB.find_all_by_subjectId(statement.objectId).collect {|s| s.objectId}
    puts children.join " "
    Nesstar::StatementEJB.find_all_by_subjectId(statement.objectId).each {|s| create_or_update_catalog(s.id, archive_id)}
  end
end