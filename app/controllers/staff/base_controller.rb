class Staff::BaseController < ApplicationController

  helper_method :current_user
  before_filter :authenticate_user!
  before_filter :redirect_if_unauthorised
  
  layout 'manage'
  
  def devise_controller?
    true
  end

  def redirect_if_unauthorised
    puts "**** #{current_user} "
    redirect_to root_path unless current_user and current_user.is_staff?     
  end
end
