class Staff::BaseController < ApplicationController

  alias current_user current_inkling_user
  helper_method :current_user
  before_filter :authenticate_inkling_user!
  
  layout 'manage'
  
end