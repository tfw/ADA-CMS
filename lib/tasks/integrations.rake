namespace :integrate do
  task :studies => :environment do
    Integrations::ArchiveCatalogs.create_or_update(Nesstar::StatementEJB.find_by_objectId("indigenous"), Archive.indigenous.id)
    Integrations::ArchiveCatalogs.create_or_update(Nesstar::StatementEJB.find_by_objectId("social-science"), Archive.social_science.id)
    Integrations::ArchiveCatalogs.create_or_update(Nesstar::StatementEJB.find_by_objectId("historical"), Archive.historical.id)
    Integrations::ArchiveCatalogs.create_or_update(Nesstar::StatementEJB.find_by_objectId("longitudinal"), Archive.longitudinal.id)
    Integrations::ArchiveCatalogs.create_or_update(Nesstar::StatementEJB.find_by_objectId("qualitative"), Archive.qualitative.id)
    Integrations::ArchiveCatalogs.create_or_update(Nesstar::StatementEJB.find_by_objectId("international"), Archive.international.id)    
  end
  
  task :related_materials => :environment do
    Integrations::RelatedMaterials.create_or_update
  end
  
  namespace :variables do
    task :indigenous => :environment do
      Integrations::Variables.create_or_update(Archive.indigenous)
    end
    
    task :qualitative => :environment do
      Integrations::Variables.create_or_update(Archive.qualitative)
    end
    
    task :international => :environment do
      Integrations::Variables.create_or_update(Archive.international)
    end

    task :social_science => :environment do
      Integrations::Variables.create_or_update(Archive.social_science)
    end

    task :historical => :environment do
      Integrations::Variables.create_or_update(Archive.historical)
    end

    task :longitudinal => :environment do
      Integrations::Variables.create_or_update(Archive.longitudinal)
    end    
  end

  task :some => :environment do
    Integrations::ArchiveCatalogs.create_or_update(Nesstar::StatementEJB.find_by_objectId("indigenous"), Archive.indigenous.id)
    Integrations::ArchiveCatalogs.create_or_update(Nesstar::StatementEJB.find_by_objectId("social-science"), Archive.social_science.id)
    Integrations::ArchiveCatalogs.create_or_update(Nesstar::StatementEJB.find_by_objectId("historical"), Archive.historical.id)
    Integrations::ArchiveCatalogs.create_or_update(Nesstar::StatementEJB.find_by_objectId("longitudinal"), Archive.longitudinal.id)
    Integrations::ArchiveCatalogs.create_or_update(Nesstar::StatementEJB.find_by_objectId("qualitative"), Archive.qualitative.id)
    Integrations::ArchiveCatalogs.create_or_update(Nesstar::StatementEJB.find_by_objectId("international"), Archive.international.id)
    Integrations::RelatedMaterials.create_or_update
    vars_in_archive(Archive.indigenous)
    vars_in_archive(Archive.qualitative)
    vars_in_archive(Archive.international)
  end
  
  task :everything => :environment do
    Integrations::ArchiveCatalogs.create_or_update(Nesstar::StatementEJB.find_by_objectId("indigenous"), Archive.indigenous.id)
    Integrations::ArchiveCatalogs.create_or_update(Nesstar::StatementEJB.find_by_objectId("social-science"), Archive.social_science.id)
    Integrations::ArchiveCatalogs.create_or_update(Nesstar::StatementEJB.find_by_objectId("historical"), Archive.historical.id)
    Integrations::ArchiveCatalogs.create_or_update(Nesstar::StatementEJB.find_by_objectId("longitudinal"), Archive.longitudinal.id)
    Integrations::ArchiveCatalogs.create_or_update(Nesstar::StatementEJB.find_by_objectId("qualitative"), Archive.qualitative.id)
    Integrations::ArchiveCatalogs.create_or_update(Nesstar::StatementEJB.find_by_objectId("international"), Archive.international.id)
    Integrations::RelatedMaterials.create_or_update
    vars_in_archive(Archive.indigenous)
    vars_in_archive(Archive.qualitative)
    vars_in_archive(Archive.international)
    vars_in_archive(Archive.historical)
    vars_in_archive(Archive.social_science)
    vars_in_archive(Archive.longitudinal)
  end
  
end

def vars_in_archive(archive)
  beginning = Time.now
  puts "Beginning #{archive.name} integration at #{Time.now}"
  Integrations::Variables.create_or_update(archive)
  puts Time.now
  diff = Time.now - beginning

  p diff  
end

