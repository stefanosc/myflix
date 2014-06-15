class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_user, :logged_in?, :require_user

  def current_user
    @current_user ||= User.find_by(id: session[:user]) if session[:user]
  end

  def logged_in?
    !!current_user
  end

  def require_user
    redirect_to sign_in_path unless current_user
    session[:referer] = request.path
  end

end
