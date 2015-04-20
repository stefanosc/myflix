class UsersController < ApplicationController
  before_action :set_user, only: [:show]
  before_action :require_user, only: [:show]

  def new
    redirect_to home_path and return if current_user
    @user = User.new
  end

  def new_with_invitation
    @user = User.new
    if used_invitation_token?
      render :used_token and return
    elsif invite = Invite.where(token: params[:invite_token]).first
      @user.invite_token, @user.name, @user.email =  invite.token, invite.invitee_name, invite.invitee_email
    else
      flash.now[:success] = "It appears you clicked on an incomplete invitation link. if you received an invitation, you can try clicking again on the register link or simply go ahead and register below"
    end
    render :new
  end

  def create
    @user = User.new(user_params)
    signup = UserSignup.new(user:         @user,
                            charge_token: stripe_token,
                            invite_token: invite_token).signup!
    if signup.successful?
      flash[:success] = signup.success_message
      redirect_to sign_in_path
    else
      # validation errors are handled by rails_bootstrap_form
      flash.now[:danger] = signup.error_message
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

  def stripe_token
    params[:stripeToken]
  end

  def invite_token
    user_params[:invite_token]
  end

  def used_invitation_token?
    User.where(invite_token: params[:invite_token]).present?
  end

end
