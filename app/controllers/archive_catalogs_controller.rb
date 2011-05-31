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
  def get_root_catalogs
    @ada_catalogs = ArchiveCatalog.find_by_archive_id_and_parent_id(Archive.ada.id, nil)
  end
  
end

