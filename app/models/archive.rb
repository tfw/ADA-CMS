class Archive < ActiveRecord::Base
  
  validates_presence_of :name
  validates_uniqueness_of :name
  
  has_many :pages
  
  # SOCIAL_SCIENCE = self.find_by_name("Social Science")
  # HISTORICAL =  self.find_by_name("Historical") 
  # INDIGENOUS =   self.find_by_name("Indigenous")
  # LONGITUDINAL =  self.find_by_name("Longitudinal")
  # QUALITATIVE =  self.find_by_name("Qualitative")
  # INTERNATIONAL =  self.find_by_name("International")

  SOCIAL_SCIENCE  = "Social Science"
  HISTORICAL      = "Historical" 
  INDIGENOUS      = "Indigenous"
  LONGITUDINAL    = "Longitudinal"
  QUALITATIVE     = "Qualitative"
  INTERNATIONAL   = "International"
  
  scope :social_science, where(:name => SOCIAL_SCIENCE) 
  scope :historical, where(:name => HISTORICAL) 
  scope :indigenous, where(:name => INDIGENOUS) 
  scope :longitudinal, where(:name => LONGITUDINAL) 
  scope :qualitative, where(:name => QUALITATIVE) 
  scope :internationl, where(:name => INTERNATIONAL) 
end