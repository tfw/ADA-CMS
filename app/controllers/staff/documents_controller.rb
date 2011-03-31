class Staff::DocumentsController < Staff::BaseController
  inherit_resources                                                                                     
  defaults :resource_class => Document, :instance_name => 'document'

  def destroy
    destroy!(:notice => 'Document deleted') { staff_resources_path }
  end

  def browse      # browse_staff_documents_path
    # Render a document browser for CKEditor
    @documents = Document.all
    render :layout => "browser"
  end

  private

  def collection
    @collection =
      @documents = end_of_association_chain.paginate(:page => params[:page], :order => 'created_at DESC')
  end
end
