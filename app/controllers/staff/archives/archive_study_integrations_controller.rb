class Staff::Archives::ArchiveStudyIntegrationsController < Staff::Archives::BaseController
  inherit_resources                                                                                     
  defaults :resource_class => ArchiveStudyIntegration, :instance_name => 'archive_study_integration'
  before_filter :get_archive
  
  def create
    create! do |format| 
      format.html {
        redirect_to staff_archive_integrations_path(@archive)   
        } 
    end
  end

  def update
    update! do |format| 
      format.html {
        redirect_to staff_archive_integrations_path(@archive)   
        } 
    end
  end

  def destroy
    destroy! do |format| 
      format.html {
        redirect_to staff_archive_integrations_path(@archive)   
        } 
    end
  end
end 
