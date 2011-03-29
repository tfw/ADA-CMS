class Staff::ResourcesController < Staff::BaseController
  def index
    @documents = Document.paginate(:page => params[:page], :order => 'created_at DESC')
    @images = Image.paginate(:page => params[:page], :order => 'created_at DESC')
  end
end
