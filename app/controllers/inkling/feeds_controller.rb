class Inkling::FeedsController < ApplicationController
  
  skip_before_filter :update_authentication, :only => :show
  respond_to :rss, :atom, :html, :xml

  def show
    @feed = Inkling::Feed.find(params[:id])
    respond_to do |format|
      format.any(:rss, :atom, :xml) do
        render :xml => @feed.generate, :layout => false
      end
      
      format.html {@feed}
    end
  end
end
