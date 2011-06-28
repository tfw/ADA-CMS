class UserSessionsController
  def new
    session[:openid_checked] = true

    if user = User.find_by_identity_url(params[:url])
      set_flash_message :notice, :signed_in
      sign_in_and_redirect :user, user
    else
      redirect_to root_url
    end
  end

  def destroy
    if signed_in? :user
      sign_out :user
      set_flash_message :notice, :signed_out
    end
    
    session[:openid_checked] = true if (params[:user] || {})[:immediate]
    redirect_to root_url
  end
end
