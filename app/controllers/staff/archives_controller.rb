require 'ada_archive'

class Staff::ArchivesController < Inkling::BaseController

  respond_to :html
  respond_to :json, :only => :update_page_order
  before_filter :get_archive, :only => :show
  before_filter :get_parent_pages, :only => :show  
  
  def show
    respond_with @archive
  end

  def update_page_order
    puts params[:pages_order]
    # debugger
    
    puts "********"
  end

  private
  def get_archive
    @archive = Archive.find_by_slug(params[:slug]) if params[:slug]
    @archive ||= ADAArchive.new
  end
  
  def get_parent_pages
    @parent_pages = Page.find_all_by_archive_id_and_parent_id(@archive.id, nil)
  end  
end
