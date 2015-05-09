class AppMailer < ActionMailer::Base
  layout 'default_email'

  def welcome_email(user)
    @user = user
    email_with_name = "#{@user.name} <#{@user.email}>"
    mail to: email_with_name, subject: 'Welcome to LoveFlix'
  end

  def failed_payment(user)
    @user = user
    email_with_name = "#{@user.name} <#{@user.email}>"
    mail to: email_with_name, subject: 'LoveFlix subscription payment failed'
  end

  def password_reset(user)
    @user = user
    email_with_name = "#{@user.name} <#{@user.email}>"
    mail to: email_with_name, subject: 'Password Reset Request'
  end

  def invite_friend(invite, inviter_name)
    @invite = invite
    @inviter_name = inviter_name
    email_with_name = "#{@invite.invitee_name} <#{@invite.invitee_email}>"
    mail to: email_with_name, subject: "#{@inviter_name} invites you to join LoveFlix"
  end

end
