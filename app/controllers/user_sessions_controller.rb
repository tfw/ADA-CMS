# see the environment to set OPENID_SERVER constant

class UserSessionsController < OpenidClient::SessionsController
  
  # after_filter :log_authentication, :only => :create
  
  protected
  # 
  # def log_authentication
  #   debugger
  #   puts "--"
  # end

  def force_default?
    true
  end

  def default_login
    OPENID_SERVER
  end

  def logout_url_for(identity)
    if identity and identity.starts_with? OPENID_SERVER
      "#{OPENID_SERVER}/logout"
    else
      nil
    end
  end
  # 
  # # Whether to bypass OpenID verification see OpenID Client Engine
  # def bypass_openid?
  #   false
  # end
end
