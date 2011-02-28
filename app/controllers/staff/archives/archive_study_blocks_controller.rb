class Staff::Archives::ArchiveStudyBlocksController < Staff::ArchivesController
  inherit_resources                                                                                     
  defaults :resource_class => ArchiveStudyBlock, :instance_name => 'archive_study_block'
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
