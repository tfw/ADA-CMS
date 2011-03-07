class SearchController < ContentController

  before_filter :set_current_archive
  
  def sphinx   
    @term = params[:term]
    @sphinx = ThinkingSphinx.search(@term, :page => params[:page], :match_mode => :any)

puts "***** #{params} ***** \n\n"
    render :results
  end

  private
  def set_current_archive
    @current_archive = Archive.ada
  end
end
