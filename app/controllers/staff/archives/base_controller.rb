class Staff::Archives::BaseController < Staff::BaseController
  
  respond_to :html
  before_filter :get_archive, :only => :show
  
  private
  def get_archive
    @archive ||= Archive.find_by_slug(params[:archive_id]) if params[:archive_id]
  end
end
