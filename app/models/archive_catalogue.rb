class ArchiveCatalogue < ActiveRecord::Base

  acts_as_nested_set  
  has_many :studies , :through => :categorizations
end