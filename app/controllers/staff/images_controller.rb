class Staff::ImagesController < Staff::BaseController
  inherit_resources                                                                                     
  defaults :resource_class => Image, :instance_name => 'image'

  def destroy
    destroy!(:notice => 'Image deleted') { staff_resources_path }
  end

  def browse      # browse_staff_images_path
    # Render an image browser for CKEditor
    
    @images = Image.all
    @pictures = Image.all
    render :layout => "browser"
  end

  private

  def collection
    @collection =
      @images = end_of_association_chain.paginate(:page => params[:page], :order => 'created_at DESC')
  end
end
