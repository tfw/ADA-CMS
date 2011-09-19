class ArchiveStudiesController < ContentController
  include HTTParty
  format :json
  
  respond_to :html
  clear_helpers
  helper :application
  helper :archive_studies
  
  def show
    @archive_study = ArchiveStudy.find_by_id(params[:id])
    @study = @archive_study.study

    if current_user
      @perms = get_study_permissions_from_ada_users(@study)
    end

    @username = current_user.identity_url.split("/").last if current_user
    @current_archive = @archive_study.archive
    @title = @study.title
    @variables = @study.variables.paginate(:page => params[:page], :per_page => 100)
    respond_with(@study)
  end
  
  def show_by_slug
    path = Inkling::Path.find_by_slug(params[:slug])
    @archive_study = path.content
    @study = @archive_study.study
    @current_archive = @archive_study.archive
    render :action => :show
  end
  private
  
  def get_study_permissions_from_ada_users(study)
    resource_id = study.stdy_id
    username = current_user.identity_url.split("/").last
    study_perms = ArchiveStudiesController.get("#{OPENID_SERVER}/users/#{username}/access/#{resource_id}?api_key=#{Secrets::API_KEY}")
    study_perms.to_hash
    {'browse' => true, 'analyse' => true, 'download' => true}
  end
end
