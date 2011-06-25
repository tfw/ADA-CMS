class ArchiveCatalogStudy < ActiveRecord::Base

  belongs_to :archive_study
  belongs_to :archive_catalog
  has_one :study, :through => :archive_study
  
  def self.create_or_update_from_nesstar(archive_study, archive_catalog, position)
    archive_catalog_study = ArchiveCatalogStudy.find_by_archive_study_id_and_archive_catalog_id(archive_study.id, archive_catalog.id)
    
    if archive_catalog_study
      if archive_catalog_study.catalog_position != position
        archive_catalog_study.catalog_position = position
        archive_catalog_study.save!
      end
    else
      self.create!(:archive_study => archive_study, :archive_catalog => archive_catalog, :catalog_position => position)
    end
  end
end