require "application_responder"

class ApplicationController < ActionController::Base
  include OpenidClient::Helpers

  rescue_from ActionController::RoutingError, :with => :four_o_four

  self.responder = ApplicationResponder
  respond_to :html

  protect_from_forgery
  before_filter :update_authentication

  # alias current_user current_inkling_user
  helper_method :current_user

  def local_request?
  false
end

  def four_o_four
  	@title = "#{request.path} 404"
    respond_to do |format| 
      format.html { render :template => "errors/404", :status => 404 } 
      format.all  { render :nothing => true, :status => 404 } 
    end
  	true
  end
end

