class StudyRelatedMaterial < ActiveRecord::Base
  
  belongs_to :study
  
  validates_presence_of :study_id

  def url
    return "http://assda-nesstar.anu.edu.au#{self.uri[2..-1]}" 
  end
end
