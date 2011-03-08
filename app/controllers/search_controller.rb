class SearchController < ContentController
  
  respond_to :html
    
  def sphinx   
    @term = params[:term]
    @current_archive = Archive.find(params[:archive_id])
    search_params = {:page => params[:page], :match_mode => :any}
    
    unless @current_archive == Archive.ada
      search_params[:archive_id] = @current_archive.id
    end
    
    @sphinx = ThinkingSphinx.search(@term, search_params)

    render :results
  end
end
