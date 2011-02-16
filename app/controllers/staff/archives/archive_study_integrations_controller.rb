class Staff::Archives::ArchiveStudyIntegrationsController < Staff::ArchivesController
  inherit_resources                                                                                     
  defaults :resource_class => ArchiveStudyIntegration, :instance_name => 'archive_study_integration'
  before_filter :get_archive
  
  def create
    create! do |format| 
      format.html {
        redirect_to archive_integrations_path(@archive.slug)   
        } 
    end
  end
end 