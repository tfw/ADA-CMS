class Staff::ArchivesController < Inkling::BaseController

  respond_to :html
  before_filter :get_archive
  
  def show
    respond_with @archive
  end

  private
  def get_archive
    @archive = Archive.find_by_slug(params[:slug]) if params[:slug]
    @archive ||= ADAArchive.new
  end

end

class ADAArchive
  
  def name
    "ADA"
  end
end