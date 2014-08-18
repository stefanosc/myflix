class UserAuthenticationController < ApplicationController

  before_action :require_user

  def require_user
    redirect_to sign_in_path unless current_user
    session[:referer] = request.path
  end
end
