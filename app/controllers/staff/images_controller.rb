class Staff::ImagesController < Staff::BaseController
  inherit_resources                                                                                     
  defaults :resource_class => Image, :instance_name => 'image'

  private

  def collection
    @collection =
      @images = end_of_association_chain.paginate(:page => params[:page], :order => 'created_at DESC')
  end
end
