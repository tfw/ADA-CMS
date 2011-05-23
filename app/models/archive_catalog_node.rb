class ArchiveCatalogNode < ActiveRecord::Base

  acts_as_nested_set  

  belongs_to :archive_study
  belongs_to :archive_catalog
  
  validate :unique_study_and_catalog
  
  def unique_study_and_catalog
    pre_existing = ArchiveCatalogNode.find_by_archive_study_id_and_archive_catalog_id(self.archive_study.id, self.archive_catalog.id)
    
    if pre_existing.size > 1
      errors.add(:archive_study, "There is already a catalog node for this archive study (#{self.archive_study.path.slug})")
    end
  end
end