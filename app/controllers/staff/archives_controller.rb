require 'ada_archive'

class Staff::ArchivesController < Inkling::BaseController

  respond_to :html
  before_filter :get_archive
  before_filter :get_parent_pages  
  
  def show
    respond_with @archive
  end

  private
  def get_archive
    @archive = Archive.find_by_slug(params[:slug]) if params[:slug]
    @archive ||= ADAArchive.new
  end
  
  def get_parent_pages
    @parent_pages = Page.find_all_by_archive_id_and_parent_id(nil)
  end
end
