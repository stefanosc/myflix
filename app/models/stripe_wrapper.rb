module StripeWrapper
  class Charge

    attr_reader :response, :status

    def initialize(response, status)
      @response = response
      @status   = status
    end

    def self.create(opts={})
      set_api_key
      begin
        response = Stripe::Charge.create(
          currency:  'usd',
          amount:    opts[:amount],
          card:      opts[:card]
        )
        new(response, :success)
      rescue Stripe::CardError => e
        new(e, :error)
      end
    end

    def successful?
      status == :success
    end

    def error_message
      response.message
    end

    def self.set_api_key
      Stripe.api_key = ENV["STRIPE_API_KEY"]
    end
  end
end