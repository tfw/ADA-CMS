class Staff::UsersController < Staff::BaseController  
  include HTTParty
  format :json
  
  inherit_resources                                                                                     
  defaults :resource_class => User, :instance_name => 'user'

  def show
    show! do 
      @logs = Inkling::Log.find_all_by_user_id(@user.id, :limit => 50, :order => "created_at DESC")
    end
  end  

  private

 # https://users.ada.edu.au/users/nicholasfaiz/details?api_key=q0bu1t2whypflaxg5ne7vz8jioc46dks
  def get_user_details(user)
  	username = current_user.identity_url.split("/").last
    study_perms = Staff::UsersController.get("#{OPENID_SERVER}/users/#{username}/details/#{user.identity_url}?api_key=#{Secrets::API_KEY}")
    study_perms.to_hash
  end
end
