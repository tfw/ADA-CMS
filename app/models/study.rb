#the basic representation of a unit of data - e.g. something imported from Nesstar

class Study < ActiveRecord::Base
  
  has_many :study_entries
end