class Archive < ActiveRecord::Base
  include Inkling::Slugs
  
  validates_presence_of :name
  validates_uniqueness_of :name
  
  validates_presence_of :slug
  before_validation :set_slug
  
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
  
  # def sluggerize(slug)
  #   text = slug.dup
  #   text.downcase!
  #   text.gsub!(/&(\d)+;/, '') # Ditch Entities
  #   text.gsub!('&', 'and') # Replace & with 'and'
  #   text.gsub!(/['"]/, '') # replace quotes by nothing
  #   text.gsub!(/\ +/, '-') # replace all white space sections with a dash
  #   text.gsub!(/(-)$/, '') # trim dashes
  #   text.gsub!(/^(-)/, '') # trim dashes
  #   text.gsub!(/[^\/a-zA-Z0-9\-]/, '-') # Get rid of anything we don't like
  #   text
  # end
  
  def set_slug
    self.slug = sluggerize(name)
  end
end