class MediaController < ApplicationController
  respond_to :html

  def show
    @media = Media.find_by_id(params[:id])
    respond_with(@media)
  end

end
