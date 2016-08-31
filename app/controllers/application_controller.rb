require "application_responder"

class ApplicationController < ActionController::Base
  include Pundit

  self.responder = ApplicationResponder
  respond_to :html, :js

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized
    respond_to do |format|
      flash[:alert] = 'You are not authorized to perform this action.'
      format.html { redirect_to(request.referrer || root_path) }
      format.js { render js: "alert('#{flash[:alert]}');", status: :forbidden }
      format.json { render json: flash[:alert], status: :forbidden}
    end
  end
end
