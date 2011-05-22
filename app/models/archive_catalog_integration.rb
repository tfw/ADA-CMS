class ArchiveCatalogIntegration < ActiveRecord::Base
  
  belongs_to :archive
  belongs_to :archive_catalog
  has_many :archive_study_integrations
  
  validates_presence_of :archive

  def label
    url.split("/").last
  end
  
  def children_file
    "#{url}@children"
  end
end