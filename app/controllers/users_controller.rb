class UsersController < ApplicationController
  before_action :set_user, only: [:show]
  before_action :require_user, only: [:show]

  def new
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
    if @user.valid?
      charge = charge_payment
      if charge.successful?
        @user.save
        handle_invitation
        AppMailer.delay.welcome_email(@user)

        flash[:success] = "Thank you for signing up ♥︎"
        redirect_to sign_in_path and return
      else
        flash[:danger] = "#{charge.error_message}"
      end
    end
    render :new
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

  def used_invitation_token?
    User.where(invite_token: params[:invite_token]).present?
  end

  def handle_invitation
    if invite = Invite.where(token: user_params[:invite_token]).first
      @user.followers << invite.inviter
      invite.inviter.followers << @user
    end
  end

  def charge_payment
    token = params[:stripeToken]

    StripeWrapper::Charge.create(
      :amount => 999,
      :card => token
    )
  end

end
