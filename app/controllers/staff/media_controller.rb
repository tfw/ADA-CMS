class Staff::MediaController < Staff::BaseController
  inherit_resources                                                                                     
  defaults :resource_class => Media, :instance_name => 'media'

  private

  def collection
    @collection =
      @media = end_of_association_chain.paginate(:page => params[:page], :order => 'created_at DESC')
  end
end
