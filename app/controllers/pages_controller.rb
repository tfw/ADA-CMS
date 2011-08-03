class PagesController < ContentController
    
  respond_to :html
  # caches_action :show, :show_by_slug, :layout => false
  
  def show
    @page = Page.find_by_id(params[:id])
    # if stale?(:last_modified => @page.updated_at.utc, :etag => @page)
      @current_archive = @page.archive
      @title = @page.title
      @archive_news = @current_archive.archive_news.find(:all, :order => "created_at DESC", :limit => 10)
      @archive_studies = @current_archive.archive_studies.find(:all, :order => "created_at DESC", :limit => 10) 
      respond_with(@page)
    # end
  end
  
  def show_by_slug
    path = Inkling::Path.find_by_slug(params[:slug])
    @page = path.content
    
    # if stale?(:last_modified => @page.updated_at.utc, :etag => @page)
      @current_archive = @page.archive
      @title = @page.title
      @archive_news = @current_archive.archive_news.find(:all, :order => "created_at DESC", :limit => 10)
      @archive_studies = @current_archive.archive_studies.find(:all, :order => "created_at DESC", :limit => 10) 

      render :action => :show
    # end
  end  
end
