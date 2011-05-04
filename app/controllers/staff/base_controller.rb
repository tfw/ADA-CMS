class Staff::BaseController < ApplicationController

  helper_method :current_user
  before_filter :authenticate_user!
  
  layout 'manage'
  
  before_filter :test
  
  def test
    debugger
  end
  
  def devise_controller?
    true
  end
  
end
