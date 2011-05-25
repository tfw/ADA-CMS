class ArchiveCatalogNode < ActiveRecord::Base

  acts_as_nested_set  

  belongs_to :archive_study
  belongs_to :archive_catalog
  
  # validates_uniqueness_of :archive_study, :if => Proc.new {|node| node.archive_study}
  # validates_uniqueness_of :archive_catalog, :if => Proc.new {|node| node.archive_catalog}
end