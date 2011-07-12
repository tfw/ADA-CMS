class RelatedMaterial < ActiveRecord::Base
  
  belongs_to :study
  validates_presence_of :stdy_id

  def self.create_or_update_from_nesstar(egms_resource)
    rm = RelatedMaterial.find_by_stdy_id_and_nesstar_id(egms_resource.studyID, egms_resource.id)
    study =  Study.find_by_stdy_id(egms_resource.studyID)
        
    attributes = egms_resource.attributes
    converted_keys = {}
    attributes.each do |k,v|
      k = "stdyID" if k == "studyID"  #for the sake of consistency with the studies table
      
      next if k == "dateAquired"
      
      converted_keys[k.underscore.to_sym] = v
    end

    converted_keys[:study_id] = study.id
    converted_keys[:nesstar_id] = egms_resource.id
    
    if rm.nil?
      rm = RelatedMaterial.create!(converted_keys)
    elsif converted_keys[:creation_date] > rm.updated_at
      rm.update_attributes(converted_keys)
    end
    
    rm
  end
end
