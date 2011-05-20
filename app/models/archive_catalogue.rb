class ArchiveCatalogue < ActiveRecord::Base

  acts_as_nested_set  
  acts_as_inkling "Catalogue"
  
  has_many :studies , :through => :categorizations
  has_one :archive_catalogue_integration
end