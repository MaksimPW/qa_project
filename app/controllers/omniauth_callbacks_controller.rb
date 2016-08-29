class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :auth, only: [:facebook]

  def facebook
  end

  protected

  def auth
    auth_hash = request.env['omniauth.auth']
    @user = User.find_for_oauth(auth_hash)
    if @user && @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: action_name.capitalize) if is_navigational_format?
    else
      session[:omniauth] = auth_hash.except('extra')
      redirect_to new_authorization_path
    end
  end
end