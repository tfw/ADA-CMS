
class Staff::ActivityLogsController < Staff::BaseController

  respond_to :html
  layout false
  
  def index
    logs = Inkling::Log.find(:all, :limit => 40, :order => "created_at DESC")
    unless logs.length < 20
	    @first_20 = logs[0..19]
	    @second_20 = logs [20..-1]
	else
		@first20 = logs[0..19]
	end
  end
end
