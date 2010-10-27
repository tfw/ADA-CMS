class ArchivesController < ContentController
  
  respond_to :html
  
  def show
    respond_with(@archive = Archive.find_by_id(params[:id]))
  end
end
