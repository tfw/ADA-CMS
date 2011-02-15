class Staff::Archives::IntegrationsController < Staff::ArchivesController
  
  before_filter :get_archive
  
  def index
    @archive_study_integration = ArchiveStudyIntegration.new
    @archive_study_query = ArchiveStudyQuery.new
    @archive_study_block = ArchiveStudyBlock.new
  end
end