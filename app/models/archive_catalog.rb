class ArchiveCatalog < ActiveRecord::Base
 
  acts_as_inkling "Catalog"
  
  has_one :archive_catalog_integration
  has_one :archive_catalog_node
  
  validates_presence_of :archive_catalog_integration
  validates_presence_of :title
end