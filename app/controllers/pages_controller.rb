class PagesController < ContentController
  
  respond_to :html
  
  def show
    @page = Page.find_by_id(params[:id])
    @title = @page.title
    respond_with(@page)
  end
  
  def show_by_slug
    path = Inkling::Path.find_by_slug(params[:slug])
    debugger
    @page = path.content
    @current_archive = @page.archive
    render :action => :show
  end
end
