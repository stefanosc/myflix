class UserSignup

  attr_reader :user, :charge_token, :invite_token, :error_message

  def initialize(user, charge_token, invite_token)
    @user = user
    @charge_token = charge_token
    @invite_token = invite_token
    @status = nil
    @error_message = nil
    signup!
  end

  def signup!
    if user.valid?
      charge = charge_payment
      if charge.successful?
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
  end

  def successful?
    @status == :success
  end

  def success_message
    "Thank you for signing up ♥︎"
  end

  private

  def handle_invitation
    if invite = Invite.find_by(token: invite_token)
      @user.followers << invite.inviter
      invite.inviter.followers << @user
    end
  end

  def charge_payment
    StripeWrapper::Charge.create(
      :amount => 999,
      :card => charge_token
    )
  end

end