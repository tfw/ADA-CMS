
class Staff::ActvityLogController < Inkling::BaseController

  respond_to :json
  
  def index
    logs = Inkling::Log.find(:all, :limit => 20, :order => "created_at DESC")
    render :json => logs.to_json
  end
end
