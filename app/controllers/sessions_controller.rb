class SessionsController < ApplicationController

  def new
    session[:referer] = request.env["HTTP_REFERER"] if session[:referer].nil?
    redirect_to home_path if current_user
  end

  def create
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      if user.delinquent?
        flash[:danger] = "Your account has been suspended due to a payment failure"
        redirect_to sign_in_path
      else
        session[:user] = user.id
        case session[:referer]
        when sign_in_path, root_path, nil, /password_reset/
          session[:referer] = home_path
        end
        redirect_to session[:referer], flash: {success: "You have successfully logged in"}
        session[:referer] = nil
      end
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