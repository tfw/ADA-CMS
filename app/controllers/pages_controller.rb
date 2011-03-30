class PagesController < ContentController
    
  respond_to :html
  
  def show
    @page = Page.find_by_id(params[:id])
    @current_archive = @page.archive
    @title = @page.title
    @news_archives = @current_archive.news_archives.find(:all, :order => "created_at DESC", :limit => 10)
    @archive_studies = @current_archive.archive_studies.find(:all, :order => "created_at DESC", :limit => 10)
    respond_with(@page)
  end
  
  def show_by_slug
    path = Inkling::Path.find_by_slug(params[:slug])
    @page = path.content
    @current_archive = @page.archive
    @title = @page.title
    render :action => :show
  end  
end
