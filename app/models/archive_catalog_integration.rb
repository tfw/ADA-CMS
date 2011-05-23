class ArchiveCatalogIntegration < ActiveRecord::Base
  
  belongs_to :archive
  belongs_to :archive_catalog
  
  validates_presence_of :archive
  validate :unique_archive_and_archive_catalog

  def unique_archive_and_archive_catalog
    pre_existing = ArchiveCatalogIntegration.find_all_by_archive_id_and_archive_catalog_id(self.archive.id, self.archive_catalog.id)
    if pre_existing.size > 1
      errors.add(:archive, "There is already a catalog integration for this archive (#{self.archive.name}) and catalog (#{archive_catalog.label})")
    end
  end

  def label
    url.split("/").last
  end
  
  def children_file
    "#{url}@children"
  end
end