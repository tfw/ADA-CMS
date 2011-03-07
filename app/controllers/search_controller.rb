class SearchController < ContentController
  
  respond_to :html
    
  def sphinx   
    @term = params[:term]
    @current_archive = Archive.find_by_id(params[:archive_id])
    @sphinx = ThinkingSphinx.search(@term, :page => params[:page], :match_mode => :any)

    render :results
  end
end
