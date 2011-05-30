class ArchiveCatalogsController < ContentController
    
  respond_to :html
  clear_helpers
  helper :application
  
  
  def show
    @catalog = ArchiveCatalog.find_by_id(params[:id])
    @current_archive = @catalog.archive
    @title = @catalog.title
    respond_with(@catalog)
  end  
  
  protected
  
end

