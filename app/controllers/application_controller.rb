require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  protect_from_forgery

  before_filter :get_archives
  
  private  
  def get_archives
    @archives = Archive.all
  end
end
