class AuthorizationsController < ApplicationController
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

  before_filter :check_session

  def new
  end

  def create
    email = params[:email]
    if email && valid_email?(email)
      session['omniauth']['info']['email'] = email
      auth = OmniAuth::AuthHash.new(session['omniauth'])
      @user = User.find_for_oauth(auth)

      flash[:notice] = t('devise.omniauth_callbacks.success', kind: session['omniauth']['provider'].to_s.capitalize!)
      sign_in_and_redirect @user, event: :authentication
    else
      flash.now[:error] = 'Email wrong!'
      render :new
    end
  end

  private

  def check_session
   unless session[:omniauth]
     flash[:error] = 'Session wrong'
     redirect_to root_path
   end
  end

  def valid_email?(email)
    email.present? && (email =~ VALID_EMAIL_REGEX)
  end
end