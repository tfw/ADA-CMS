class Integrations::RelatedMaterials

  def self.create_or_update
    for study in Study.all
      egms_resource = EGMSResourceEJB.find_by_studyID(study.stdy_id)
      RelatedMaterial.create_or_update_from_nesstar(egms_resource)
    end
  end  
end 