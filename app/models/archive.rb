class Archive < ActiveRecord::Base
  
  validates_presence_of :name
  validates_uniqueness_of :name
  
  has_many :pages

  SOCIAL_SCIENCE  = "Social Science"
  HISTORICAL      = "Historical" 
  INDIGENOUS      = "Indigenous"
  LONGITUDINAL    = "Longitudinal"
  QUALITATIVE     = "Qualitative"
  INTERNATIONAL   = "International"
  
  def self.social_science    
    Archive.find_by_name(SOCIAL_SCIENCE)
  end

  def self.historical
    Archive.find_by_name(HISTORICAL)
  end  

  def self.indigenous
    Archive.find_by_name(INDIGENOUS)
  end
  
  def self.longitudinal
    Archive.find_by_name(LONGITUDINAL)
  end
  
  def self.qualitative
    Archive.find_by_name(QUALITATIVE)
  end
  
  def self.international
    Archive.find_by_name(INTERNATIONAL)
  end
end