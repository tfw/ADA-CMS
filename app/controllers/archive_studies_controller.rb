class ArchiveStudiesController < ContentController
  
  respond_to :html
  clear_helpers
  helper :application
  helper :archive_studies
  
  def show
    @archive_study = ArchiveStudy.find_by_id(params[:id])
    @study = @archive_study.study
    @current_archive = @archive_study.archive
    @title = @study.title
    respond_with(@study)
  end
  
  def show_by_slug
    path = Inkling::Path.find_by_slug(params[:slug])
    @archive_study = path.content
    @study = @archive_study.study
    @current_archive = @archive_study.archive
    render :action => :show
  end
end
