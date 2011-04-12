class UserSessionsController < OpenidClient::SessionsController
  
  protected
  
  def force_default
    true
  end
  
  # def default_login
  #   #  openid.assda.edu.au/joid/user
  #   'http://falo.anu.edu.au:3000/'
  # end
end
