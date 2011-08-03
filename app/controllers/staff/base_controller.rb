class Staff::BaseController < ApplicationController

  PERMITTED_ROLES = [Inkling::Role.find_by_name("administrator"),
  					Inkling::Role.find_by_name("Manager"),
  					Inkling::Role.find_by_name("Approver"),
  					Inkling::Role.find_by_name("Archivist")]

  helper_method :current_user
  before_filter :authenticate_user!
  before_filter :redirect_if_unauthorised
  
  layout 'manage'
  
  def devise_controller?
    true
  end

  def redirect_if_unauthorised
  	puts "------------"
  	debugger
  	unless (current_user.roles & PERMITTED_ROLES).any?
  		redirect_to root_path
  	end
  end
end
