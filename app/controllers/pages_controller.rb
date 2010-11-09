class PagesController < ContentController
  
  respond_to :html
  
  def show
    @page = Page.find_by_id(params[:id])
    respond_with(@page)
  end
end
