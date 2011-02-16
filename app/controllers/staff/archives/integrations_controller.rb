class Staff::Archives::IntegrationsController < Staff::ArchivesController
  
  before_filter :get_archive
  
  def index; end
end