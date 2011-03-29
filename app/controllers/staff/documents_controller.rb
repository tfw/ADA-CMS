class Staff::DocumentsController < Staff::BaseController
  inherit_resources                                                                                     
  defaults :resource_class => Document, :instance_name => 'document'

  private

  def collection
    @collection =
      @documents = end_of_association_chain.paginate(:page => params[:page], :order => 'created_at DESC')
  end
end
