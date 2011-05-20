class ArchiveCatalogueNode < ActiveRecord::Base

  acts_as_nested_set  

  belongs_to :archive_study
  belongs_to :archive_catalogue
end