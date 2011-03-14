class SearchController < ContentController
  
  respond_to :html
    
  def sphinx   
    @term = params[:term]
    @current_archive = Archive.find(params[:archive_id])
  
    @sphinx = ThinkingSphinx.search(@term, :page => params[:page], :conditions => {:archive_id => @current_archive.id})

    render :results
  end
end
