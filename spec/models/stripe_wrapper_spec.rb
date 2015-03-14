require 'rails_helper'

RSpec.describe StripeWrapper, type: :model do
  describe StripeWrapper::Charge do
    describe '.create' do
      let(:token) do
        Stripe::Token.create(
          card: {
            number: card_number,
            exp_month: 2,
            exp_year: 2016,
            cvc: "314"
          }
        ).id
      end
      context "with valid credit_card" do
        let(:card_number) { "4242424242424242" }

        it "successfully charges the card", :vcr do
          charge = StripeWrapper::Charge.create(
            amount: 300,
            card: token
          )
          expect(charge).to  be_successful
          expect(charge.response.amount).to  eq(300)
          expect(charge.response.currency).to  eq('usd')
        end
      end

      context "with invalid credit_card" do
        let(:card_number) { "4000000000000002" }
        let(:charge) do
          StripeWrapper::Charge.create(
            amount: 300,
            card: token
          )
        end

        it "does not charge the card", :vcr do
          expect(charge).not_to  be_successful
        end
        it "returns an error message", :vcr do
          expect(charge.error_message).to  be_present
        end
      end
    end
  end
end
