class DatasetRelatedMaterial < ActiveRecord::Base
  
  belongs_to :dataset
  
  validates_presence_of :dataset_id

  def url
    return "http://assda-nesstar.anu.edu.au#{self.uri[2..-1]}" 
  end
end
