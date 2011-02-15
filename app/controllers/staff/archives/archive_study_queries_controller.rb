class Staff::Archives::ArchiveStudyQueriesController < Staff::ArchivesController
  inherit_resources                                                                                     
  defaults :resource_class => ArchiveStudyQuery, :instance_name => 'archive_study_query'
end