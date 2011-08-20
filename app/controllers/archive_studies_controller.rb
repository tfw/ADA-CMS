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

    # if current_user
    #   perms = get_study_permissions_from_ada_users(@study)
    # end

    @current_archive = @archive_study.archive
    @title = @study.title
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
    #this actually works!
    resource_id = study.stdy_id
    username = current_user.identity_url.split("/").last
    p ArchiveStudiesController.get("http://#{OPENID_SERVER}/users/#{username}/access/#{resource_id}?api_key=")
  end
end
