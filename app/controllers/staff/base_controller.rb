class Staff::BaseController < ApplicationController


  helper_method :current_user
  before_filter :authenticate_user!
  before_filter :redirect_if_unauthorised
  
  layout 'manage'
  
  def devise_controller?
    true
  end

  def redirect_if_unauthorised
  	unless (current_user.roles & permitted_roles).any?
  		redirect_to root_path
  	end
  end

  private
  def permitted_roles
    [Inkling::Role.find_by_name("Manager"),
      Inkling::Role.find_by_name("Publisher"),
      Inkling::Role.find_by_name("Approver"),
      Inkling::Role.find_by_name("Archivist")]
  end
end
