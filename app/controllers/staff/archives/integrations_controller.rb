class Staff::Archives::IntegrationsController < Staff::Archives::BaseController
  
  before_filter :get_archive
  
  def index; end
end