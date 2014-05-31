class PasswordResetsController < ApplicationController

  def new
  end

  def create
    if user = User.find_by(email: params[:email])
      user.update(password_reset: SecureRandom.urlsafe_base64, password_reset_created_at: Time.now)
      AppMailer.password_reset(user).deliver
      render "pages/confirm_password_reset"
    else
      flash.now[:danger] = "The email you entered is invalid"
      render :new
    end
  end

  def edit
    render "pages/invalid_token" unless user_with_valid_password_reset
  end

  def update
    if user_with_valid_password_reset
      if @user.update(password: params[:password])
        flash[:success] = "Your password has been updated, you can sign in below"
        redirect_to sign_in_path
      else
        flash.now[:danger] = "Your password could not be updated, make sure it is at least 4 characters long"
        render :edit
      end
    else
      render "pages/invalid_token"
    end
  end

  private

  def user_with_valid_password_reset
    user = User.find_by(password_reset: params[:password_reset])

    if user && user.password_reset_created_at + 30.minutes >= Time.now
      @user = user
    else
      nil
    end
  end

end
