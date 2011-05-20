class ArchiveCatalogueIntegration < ActiveRecord::Base
  
  belongs_to :archive
  belongs_to :archive_catalogue

end