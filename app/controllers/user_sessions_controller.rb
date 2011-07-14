# see the environment to set OPENID_SERVER constant

class UserSessionsController < OpenidClient::SessionsController

  protected
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
end
