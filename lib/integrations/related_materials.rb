class Integrations::RelatedMaterials

  def self.create_or_update_by_study(study)
    GC.start
    egms_resources = Nesstar::EGMSResourceEJB.find_all_by_studyID(study.stdy_id)
    
    for egms_resource in egms_resources
      RelatedMaterial.create_or_update_from_nesstar(egms_resource)
    end
  end
end 