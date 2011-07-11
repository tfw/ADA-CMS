# coding: utf-8
require 'ruby-debug'

class Integrations::ArchiveCatalogs
  
  def self.create_or_update(statement, archive_id) 
    data = statement.attributes
    parent = ArchiveCatalog.find_by_title(data["subjectId"])
    archive = Archive.find(archive_id)

    if data["objectType"] == "fCatalog"
      catalog_ejb = Nesstar::CatalogEJB.find_by_id(statement.objectId)

      if catalog_ejb.label.index("¤") 
        data[:label] = catalog_ejb.label.split("¤").last
      else
        data[:label] = catalog_ejb.label
      end
  
      data[:label] = catalog_ejb.label
              
      archive_catalog = ArchiveCatalog.create_or_update_from_nesstar(data, archive, parent)
    elsif data["objectType"] == "fStudy"
      studyejb = Nesstar::StudyEJB.find_by_stdyID(statement.objectId)
      study = Study.create_or_update_from_nesstar(studyejb.attributes)
      archive_study = ArchiveStudy.create_or_update_from_nesstar(study, archive)
      #plus, we create one for the ADA context, when searching
      archive_study = ArchiveStudy.create_or_update_from_nesstar(study, Archive.ada)
      ArchiveCatalogStudy.create_or_update_from_nesstar(archive_study, parent, data['predicateIndex'])
    end

    Nesstar::StatementEJB.find_all_by_subjectId(statement.objectId).each {|s| create_or_update(s, archive_id)}
  end
end