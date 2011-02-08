class ContentController < ApplicationController # Inkling::ContentController
  
  layout 'content' #this file is created by the Theme functionality in admin, and written out to tmp/inkling/themes/layouts
  alias current_user current_inkling_user
  helper_method :current_user
  
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
