require "application_responder"

class ApplicationController < ActionController::Base
  include OpenidClient::Helpers

  self.responder = ApplicationResponder
  respond_to :html

  protect_from_forgery

  before_filter :update_authentication

  # alias current_user current_inkling_user
  helper_method :current_user
end
