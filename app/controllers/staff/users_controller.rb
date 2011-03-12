class Staff::UsersController < Staff::BaseController
  inherit_resources                                                                                     
  defaults :resource_class => Inkling::User, :instance_name => 'user'
  
  def show
    show! do 
      @logs = Inkling::Log.find_all_by_user_id(@user.id, :limit => 50, :order => "created_at DESC")
    end
  end
  
end
