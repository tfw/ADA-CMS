class PagesController < ContentController
  
  respond_to :html
  
  def show
    @page = Page.find_by_id(params[:id])
    respond_with(@page)
  end
  
  def show_by_slug
    puts " ***** #{params[:slug]}"
    path = Inkling::Path.find_by_slug(params[:slug])
    @page = path.content
    render :action => :show
  end
end
