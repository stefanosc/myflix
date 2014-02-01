class SessionsController < ApplicationController

  def new
    session[:referer] = request.env["HTTP_REFERER"]
    redirect_to home_path if current_user    
  end

  def create
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      session[:user] = user.id
      session[:referer] = home_path if session[:referer] == sign_in_path || root_url
      redirect_to session[:referer], flash: {success: "You have successfully looged in"}
    else
      flash.now[:danger] = "The Email and Password combination you entered does not match"
      render :new
    end
  end

  def destroy
    session[:user] = nil
    redirect_to root_path, flash: {success:  "You have signed out"}
  end

end