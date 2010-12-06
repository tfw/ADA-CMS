class StudyIntegrationBlock < ActiveRecord::Base

  belongs_to :archive
  
  validates_uniqueness_of :ddi_id

  def resource_url
    return "http://bonus.anu.edu.au:80/obj/fStudy/au.edu.anu.assda.ddi.#{ddi_id}"
  end
end
