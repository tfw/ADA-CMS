class ArchiveCatalogStudy < ActiveRecord::Base

  belongs_to :archive_study
  belongs_to :archive_catalog
  has_one :study, :through => :archive_study
end