class DocumentsController < ApplicationController
  respond_to :html

  def show
    @document = Document.find_by_id(params[:id])
    send_file @document.resource.path, :type => @document.resource.content_type
  end

end
