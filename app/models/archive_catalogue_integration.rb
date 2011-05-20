class ArchiveCatalogueIntegration < ActiveRecord::Base
  
  belongs_to :archive
  belongs_to :archive_catalogue
  
  validates_presence_of :archive

  def label
    url.split("/").last
  end
  
  def children_file
    "#{url}@children"
  end
end