class Integrations::Workflow
  
  def self.integrate(catalog_name, archive)

    log = Inkling::Log.create!(:category => "integration", :text => "#{archive.name} integration began.")
    statement = Nesstar::StatementEJB.find_by_objectId("indigenous")

    Integrations::ArchiveCatalogs.create_or_update(statement, archive)

    var_count = Variable.count(:conditions => ["updated_at > ?", log.created_at])
    Inkling::Log.create!(:category => "integration", :text => "#{archive.name} integration finished. #{var_count} new variables.")
  end
  
end