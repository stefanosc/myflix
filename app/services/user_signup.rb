class UserSignup

  attr_reader :user, :error_message, :charge_token, :invite_token

  def initialize(user:, charge_token:, invite_token:)
    @user = user
    @charge_token = charge_token
    @invite_token = invite_token
    @status = nil
    @error_message = nil
  end

  def successful?
    @status == :success
  end

  def success_message
    "Thank you for signing up ♥︎"
  end

  def signup!
    if user.valid?
      charge = charge_payment
      if charge.successful?
        user.stripe_id = charge.stripe_id
        user.save
        handle_invitation
        AppMailer.delay.welcome_email(@user)
        @status = :success
      else
        @error_message = charge.error_message
        @status = :error
      end
    else
      @status = :error
    end
    self
  end

  private

  def handle_invitation
    if invite = Invite.where(token: invite_token).first
      @user.followers << invite.inviter
      invite.inviter.followers << @user
    end
  end

  def charge_payment
    StripeWrapper::Customer.create(
      email: user.email,
      source: charge_token
    )
  end

end