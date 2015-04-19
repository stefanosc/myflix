class UserSignup

  attr_reader :user, :error_message

  def initialize(user, charge_token, invite_token)
    @user = user
    @status = nil
    @error_message = nil
    signup(charge_token, invite_token)
  end

  def successful?
    @status == :success
  end

  def success_message
    "Thank you for signing up ♥︎"
  end

  private

  def signup(charge_token, invite_token)
    if user.valid?
      charge = charge_payment(charge_token)
      if charge.successful?
        user.save
        handle_invitation(invite_token)
        AppMailer.delay.welcome_email(@user)
        @status = :success
      else
        @error_message = charge.error_message
        @status = :error
      end
    else
      @status = :error
    end
  end

  def handle_invitation(invite_token)
    if invite = Invite.where(token: invite_token).first
      @user.followers << invite.inviter
      invite.inviter.followers << @user
    end
  end

  def charge_payment(charge_token)
    StripeWrapper::Charge.create(
      :amount => 999,
      :card => charge_token
    )
  end

end