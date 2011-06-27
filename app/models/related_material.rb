class RelatedMaterial < ActiveRecord::Base
  
  belongs_to :study
  validates_presence_of :stdy_id

  def self.create_or_update_from_nesstar(egms_resource)
    rm = RelatedMaterial.find_by_study_id(egms_resource.studyID)
    
    attributes = egms_resource.attributes
    converted_keys = {}
    attributes.each do |k,v|
      k = "stdyID" if k == "studyID" #for the sake of consistency with the studies table
      next if k == "dateAquired"
      
      converted_keys[k.underscore.to_sym] = v
    end

    if rm.nil?
      rm = RelatedMaterial.create!(converted_keys)
    else
      rm.update_attributes(converted_keys)
    end
    
    rm
  end
  
  # def url
  #   return "http://assda-nesstar.anu.edu.au#{self.uri[2..-1]}" 
  # end
end
