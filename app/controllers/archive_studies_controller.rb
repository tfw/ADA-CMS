class ArchiveStudiesController < ContentController
  
  respond_to :html
  
  def show
    @study = Study.find_by_id(params[:id])
    @title = @study.title
    respond_with(@study)
  end
  
  def show_by_slug
    path = Inkling::Path.find_by_slug(params[:slug])
    @study = path.content
    render :action => :show
  end
end
