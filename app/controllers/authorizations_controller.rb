class AuthorizationsController < ApplicationController
  before_filter :check_session

  def new
  end

  def create
    if @user = OauthCheck.new(session).create_auth(params[:email])
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
end