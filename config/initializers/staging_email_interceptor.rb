class StagingEmailInterceptor
  def self.delivering_email(message)
    message.to = ['loveflix99@gmail']
  end
end

ActionMailer::Base.register_interceptor(StagingEmailInterceptor) if Rails.env.staging?