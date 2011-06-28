class Integrations::RelatedMaterials

  def self.create_or_update
    for study in Study.all
      egms_resources = Nesstar::EGMSResourceEJB.find_all_by_studyID(study.stdy_id)
      
      for egms_resource in egms_resources
        RelatedMaterial.create_or_update_from_nesstar(egms_resource)
      end
    end
  end  
end 