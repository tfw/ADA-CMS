class Staff::BaseController < ApplicationController

  helper_method :current_user
  before_filter :authenticate_user!
  before_filter :redirect_if_unauthorised
  before_filter :update_authentication_on_content #in case the user logs out externally

  layout 'manage'
  
  def devise_controller?
    true
  end

  def redirect_if_unauthorised
    redirect_to root_path unless current_user and current_user.is_staff?     
  end

  protected
  def update_authentication_on_content
    update_authentication 
  end
end
