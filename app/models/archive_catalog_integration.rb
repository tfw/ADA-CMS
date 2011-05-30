class ArchiveCatalogIntegration < ActiveRecord::Base
  
  belongs_to :archive
  belongs_to :archive_catalog
  
  validates_presence_of :archive

  def uniqueness_of_url_and_archive
    pre_existing = self.find_all_by_url_and_archive_id(self.url, archive_id)
    pre_existing.delete(self)
    
    if pre_existing.any?
      errors.add(:archive, "There is already an integration for url: #{self.url} in #{archive.name}")
    end
  end

  def label
    url.split("/").last
  end
  
  def children_file
    "#{url}@children"
  end
end