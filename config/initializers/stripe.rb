Stripe.api_key = ENV["STRIPE_API_KEY"]

StripeEvent.configure do |events|
  events.subscribe 'charge.succeeded' do |event|
    user = User.find_by(stripe_id: event.data.object.customer)
    Payment.create(user: user,
                   amount: event.data.object.amount,
                   stripe_payment_id: event.data.object.id)
  end

  events.subscribe 'charge.failed' do |event|
    user = User.find_by(stripe_id: event.data.object.customer)
    user.update_attribute(:delinquent, true)
    AppMailer.delay.failed_payment(user)
  end
end