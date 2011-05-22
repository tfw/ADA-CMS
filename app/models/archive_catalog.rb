class ArchiveCatalog < ActiveRecord::Base

  acts_as_nested_set  
  acts_as_inkling "Catalog"
  
  has_many :studies , :through => :categorizations
  has_one :archive_catalog_integration
end