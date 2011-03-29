class DocumentsController < ApplicationController
  respond_to :html

  def show
    @document = Documents.find_by_id(params[:id])
    respond_with(@document)
  end

end
