class ArchiveCatalogIntegration < ActiveRecord::Base
  
  belongs_to :archive
  belongs_to :archive_catalog
  
  validates_presence_of :archive
  validates_uniqueness_of :url

  def label
    url.split("/").last
  end
  
  def children_file
    "#{url}@children"
  end
end