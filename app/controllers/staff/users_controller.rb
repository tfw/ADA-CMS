class Staff::UsersController < Staff::BaseController
  inherit_resources                                                                                     
  defaults :resource_class => UserReport, :instance_name => 'user'
  
  def show
    show! do 
      @logs = Inkling::Log.find_all_by_user_id(@user_report.id, :limit => 50, :order => "created_at DESC")
    end
  end
  
end
