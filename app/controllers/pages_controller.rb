class PagesController < Inkling::ContentController
  
  respond_to :html
  
  def show
    respond_with(@page = Page.find_by_id(params[:id]))
  end
end
