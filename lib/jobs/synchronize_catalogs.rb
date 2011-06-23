#objectId is the name of the catalog
#subjectId is the name of the parent

class Jobs::SynchronizeCatalogs < Struct.new(:objectId, :archive_id)

  def perform
    statement = Nesstar::StatementEJB.find_by_objectId(objectId)
    statement_hash = statement.attributes
    parent = ArchiveCatalog.find_by_title(statement_hash["subjectId"])
    archive = Archive.find(archive_id)

    if statement_hash["objectType"] == "fCatalog"
      archive_catalog = ArchiveCatalog.create_or_update_from_nesstar(statement_hash, archive, parent)
      puts archive_catalog
    elsif statement_hash["objectType"] == "fStudy"
      puts "create a study"
      puts "create an archive_study"
      puts "create an archive_catalog_study"      
    end
  end
end