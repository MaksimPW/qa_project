require "application_responder"

class ApplicationController < ActionController::Base
  include Pundit

  self.responder = ApplicationResponder
  respond_to :html, :js

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from Pundit::NotAuthorizedError do |e|
    redirect_to root_url, alert: e.message
  end
end
