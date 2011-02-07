class ContentController < Inkling::ContentController
  
  # inkling_content_controller
  
  before_filter :get_archives
  before_filter :get_ada_pages

  helper_method :current_archive
  
  def current_archive
    @current_archive = Archive.find(params[:archive_id]) if @current_archive.nil?
    @current_archive
  end

  protected    
  def get_ada_pages
    @ada_parent_pages = Page.archive_roots(nil)
  end

  def get_archives
    @archives = Archive.all
  end
end
