class Staff::IntegrationsController < Staff::BaseController
  
  before_filter :get_archive
  
  def index; end
  
  private
  def get_archive
    @archive = Archive.find_by_slug(params[:slug]) if params[:slug]
  end
end