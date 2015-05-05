module StripeWrapper
  class Charge

    attr_reader :response, :status

    def initialize(response, status)
      @response = response
      @status   = status
    end

    def self.create(opts={})
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

  end

  class Customer

    attr_reader :response, :status

    def initialize(response, status)
      @response = response
      @status   = status
    end

    def self.create(source:, email:, plan: "basic-plan")
      begin
        response = Stripe::Customer.create(
                     source: source,
                     plan:   plan,
                     email:  email
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

    def stripe_id
      response.id
    end
  end
end

