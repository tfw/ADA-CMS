namespace :integrate do
  
  task :indigenous => :environment do
    Integrations::Workflow.integrate("indigenous", Archive.indigenous)
  end

  task :social_science => :environment do
    Integrations::Workflow.integrate("social-science", Archive.social_science)
  end

  task :historical => :environment do
    Integrations::Workflow.integrate("historical", Archive.historical)
  end

  task :longitudinal => :environment do
    Integrations::Workflow.integrate("longitudinal", Archive.longitudinal)
  end
  
  task :qualitative => :environment do
    Integrations::Workflow.integrate("qualitative", Archive.qualitative)
  end
  
  task :international => :environment do
    Integrations::Workflow.integrate("international", Archive.international)
  end
  
  task :crime => :environment do
    Integrations::Workflow.integrate("Catalog37", Archive.crime)
  end
end

