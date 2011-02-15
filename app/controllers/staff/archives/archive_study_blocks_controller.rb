class Staff::Archives::ArchiveStudyBlocksController < Staff::ArchivesController
  inherit_resources                                                                                     
  defaults :resource_class => ArchiveStudyBlock, :instance_name => 'archive_study_blocks'
end