class PagesController < ContentController
    
  respond_to :html
  helper_method :current_archive
  
  def show
    @page = Page.find_by_id(params[:id])
    @current_archive = @page.archive
    @title = @page.title
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
