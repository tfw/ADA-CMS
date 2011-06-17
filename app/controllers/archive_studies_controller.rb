require 'net/http'

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
    # get_study_permissions_from_ada_users(@study)
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
    resource_id = study.about.gsub("http://","")
    # debugger
    # Net::HTTP.start("users.ada.edu.au/access?id=#{current_user.identity_url}&resource=#{resource_id}") do |http|
    #   p response.body
    # end
    puts ArchiveStudiesController.get("http://users.ada.edu.au/access", 
                  :query => {:id => current_user.identity_url, :resource => resource_id, :output => 'json'})
    
    # get('http://whoismyrepresentative.com/whoismyrep.php', :query => {:zip => zip, :output => 'json'})
    
  end
end
