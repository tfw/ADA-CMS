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
    self.find_by_name(SOCIAL_SCIENCE)
  end

  def self.historical
    self.find_by_name(HISTORICAL)
  end  

  def self.indigenous
    self.find_by_name(INDIGENOUS)
  end
  
  def self.longitudinal
    self.find_by_name(LONGITUDINAL)
  end
  
  def self.qualitative
    self.find_by_name(QUALITATIVE)
  end
  
  def self.international
    self.find_by_name(INTERNATIONAL)
  end
end