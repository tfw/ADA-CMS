class ImagesController < ContentController
    
  respond_to :html
  
  def show
    @image = Image.find_by_id(params[:id])
    send_file @image.resource.path, :type => @image.resource.content_type
  end
end
