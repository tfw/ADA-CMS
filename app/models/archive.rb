class Archive < ActiveRecord::Base
  acts_as_inkling 'Archive'
  
  validates_presence_of :name
  validates_uniqueness_of :name
  
  has_many :pages
  
  SOCIAL_SCIENCE = self.find_by_name("Social Science")
  HISTORICAL =  self.find_by_name("Historical") 
  INDIGENOUS =   self.find_by_name("Indigenous")
  LONGITUDINAL =  self.find_by_name("Longitudinal")
  QUALITATIVE =  self.find_by_name("Qualitative")
  INTERNATIONAL =  self.find_by_name("International")

end