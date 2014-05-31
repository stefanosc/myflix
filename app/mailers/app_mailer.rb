class AppMailer < ActionMailer::Base
  layout 'default_email'

  def welcome_email(user)
    @user = user
    email_with_name = "#{@user.name} <#{@user.email}>"
    mail to: email_with_name, subject: 'Welcome to LoveFlix'
  end

  def password_reset(user)
    @user = user
    email_with_name = "#{@user.name} <#{@user.email}>"
    mail to: email_with_name, subject: 'Password Reset Request'
  end

end
