class Staff::BaseController < ApplicationController

  helper_method :current_user
  before_filter :authenticate_user!
  
  layout 'manage'
  
end
