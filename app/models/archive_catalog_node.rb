class ArchiveCatalogNode < ActiveRecord::Base

  acts_as_nested_set  

  belongs_to :archive_study
  belongs_to :archive_catalog
  
  validates_uniqueness_of :archive_study, :if => "self.archive_study"
  validates_uniqueness_of :archive_catalog, :if => "self.archive_catalog"
end