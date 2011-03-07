class SearchController < ApplicationController

  def sphinx
    
    puts "params from controller:  #{params} *******\n"
    @term = params[:term]
    @sphinx = ThinkingSphinx.search(@term, :page => params[:page], :match_mode => :any)

    render :results
  end

end
