class ApplicationController < ActionController::Base
  protect_from_forgery

  private

  def current_user
    @current_user ||= User.find(session[:login]) if session[:login]
  end
  helper_method :current_user
end
