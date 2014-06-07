class UsersController < ApplicationController
  before_action :set_user, only: [:show]
  before_action :require_user, only: [:show]

  def new
    @user = User.new
    if invite = Invite.where(token: params[:invite_token]).first
      @user.invite_token, @user.name, @user.email =  invite.token, invite.invitee_name, invite.invitee_email
    end
  end

  def create
    @user = User.new(user_params)

    if @user.save
      if invite = Invite.where(token: user_params[:invite_token]).first
        @user.followers << invite.inviter
        invite.inviter.followers << @user
      end
      flash[:success] = "You have successfully registered"
      AppMailer.welcome_email(@user).deliver
      redirect_to sign_in_path
    else
      render :new
    end
  end

  def show
  end

  private

  def set_user
    @user = User.find_by(token: params[:id]) if params[:id]
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :invite_token)
  end

end
