
class Staff::ActivityLogsController < Inkling::BaseController

  respond_to :html
  layout false
  
  def index
    @logs = Inkling::Log.find(:all, :limit => 20, :order => "created_at DESC")
  end
end
