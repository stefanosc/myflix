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
    require 'pry'; binding.pry
    charge_payment

    if @user.save
      if invite = Invite.where(token: user_params[:invite_token]).first
        @user.followers << invite.inviter
        invite.inviter.followers << @user
      end
      flash[:success] += "You have successfully registered"
      AppMailer.delay.welcome_email(@user)
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

  def used_invitation_token?
    User.where(invite_token: params[:invite_token]).present?
  end

  def charge_payment
    Stripe.api_key = ENV["STRIPE_API_KEY"]
    token = params[:stripeToken]

    begin
      charge = Stripe::Charge.create(
        :amount => 999,
        :currency => "usd",
        :card => token
      )
      flash[:success] = "Thank you for your payment\n"
    rescue Stripe::CardError => e
      flash[:danger] = "#{e.message}"
      render :new and return
    end
  end

end
