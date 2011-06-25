class ArchiveCatalogStudy < ActiveRecord::Base

  belongs_to :archive_study
  belongs_to :archive_catalog
  has_one :study, :through => :archive_study
  
  def self.create_or_update_from_nesstar(archive_study, archive_catalog)
    archive_catalog_study = ArchiveCatalogStudy.find_by_archive_study_id_and_archive_catalog_id(archive_study.id, archive_catalog.id)
    
    unless archive_catalog_study
      self.create!(:archive_study => archive_study, :archive_catalog => archive_catalog)
    end
  end
end