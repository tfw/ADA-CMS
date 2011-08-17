class UserSessionsController
  def new
    session[:openid_checked] = true

    url  = params[:url]
    user = is_immediate_request? ? retrieve_user : User.find_by_identity_url(url)
    remember_user user

    if user
      set_flash_message :notice, :signed_in
      sign_in_and_redirect :user, user
    else
      redirect_to root_url
    end
  end

  def destroy
    session[:openid_checked] = true if is_immediate_request?
    remember_user nil

    if signed_in? :user
      sign_out :user
      set_flash_message :notice, :signed_out
    end
    
    redirect_to root_url
  end

  private

  def is_immediate_request?
    (params[:user] || {})[:immediate]
  end

  def remember_user(user)
    Thread.current[:oid_user] = user
  end

  def retrieve_user
    Thread.current[:oid_user]
  end
end
