class Staff::Archives::ArchiveStudyIntegrationsController < Staff::ArchivesController
  inherit_resources                                                                                     
  defaults :resource_class => ArchiveStudyIntegration, :instance_name => 'archive_study_integration'
end