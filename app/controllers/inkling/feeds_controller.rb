class Inkling::FeedsController < ApplicationController
  
  skip_before_filter :update_authentication, :only => :show
  respond_to :rss, :atom, :html, :xml

  #this assumes a format of xml. For other formats simply inherit from the controller and override show
  def show

puts "\n\n --- #{request.format} #{request.env["HTTP_ACCEPT"]} --- \n\n"
    
    @feed = Inkling::Feed.find(params[:id])
    respond_to do |format|
      format.any(:rss, :atom, :xml) do
        render :xml => @feed.generate, :layout => false
      end
      
      format.html {@feed}
    end
  end
end
