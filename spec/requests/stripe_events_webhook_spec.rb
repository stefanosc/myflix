require "rails_helper"

RSpec.describe "Stripe Events webhook", :vcr, :type => :request do

  let(:email) { "lala@lala.com" }
  let(:stripe_id) { "cus_6BUDgcCU5AF483" }
  let(:event_data) {
    {
      "id" => "evt_15z7EeJ1hgInCYPRThgEmVRR",
      "created" => 1430836884,
      "livemode" => false,
      "type" => "charge.succeeded",
      "data" => {
        "object" => {
          "id" => "ch_15z7EeJ1hgInCYPRdIjOlFDI",
          "object" => "charge",
          "created" => 1430836884,
          "livemode" => false,
          "paid" => true,
          "status" => "paid",
          "amount" => 999,
          "currency" => "usd",
          "refunded" => false,
          "source" => {
            "id" => "card_15z7EcJ1hgInCYPRiVbHI3FQ",
            "object" => "card",
            "last4" => "4242",
            "brand" => "Visa",
            "funding" => "credit",
            "exp_month" => 5,
            "exp_year" => 2016,
            "fingerprint" => "WOcHlI8o4CO1E025",
            "country" => "US",
            "name" => nil,
            "address_line1" => nil,
            "address_line2" => nil,
            "address_city" => nil,
            "address_state" => nil,
            "address_zip" => nil,
            "address_country" => nil,
            "cvc_check" => "pass",
            "address_line1_check" => nil,
            "address_zip_check" => nil,
            "dynamic_last4" => nil,
            "metadata" => {},
            "customer" => "cus_6BUDgcCU5AF483"
          },
          "captured" => true,
          "card" => {
            "id" => "card_15z7EcJ1hgInCYPRiVbHI3FQ",
            "object" => "card",
            "last4" => "4242",
            "brand" => "Visa",
            "funding" => "credit",
            "exp_month" => 5,
            "exp_year" => 2016,
            "fingerprint" => "WOcHlI8o4CO1E025",
            "country" => "US",
            "name" => nil,
            "address_line1" => nil,
            "address_line2" => nil,
            "address_city" => nil,
            "address_state" => nil,
            "address_zip" => nil,
            "address_country" => nil,
            "cvc_check" => "pass",
            "address_line1_check" => nil,
            "address_zip_check" => nil,
            "dynamic_last4" => nil,
            "metadata" => {},
            "customer" => "cus_6BUDgcCU5AF483"
          },
          "balance_transaction" => "txn_15z7EeJ1hgInCYPRp7wTIUvZ",
          "failure_message" => nil,
          "failure_code" => nil,
          "amount_refunded" => 0,
          "customer" => "cus_6BUDgcCU5AF483",
          "invoice" => "in_15z7EeJ1hgInCYPRNMM6CorE",
          "description" => nil,
          "dispute" => nil,
          "metadata" => {},
          "statement_descriptor" => "loveflix basic plan",
          "fraud_details" => {},
          "receipt_email" => nil,
          "receipt_number" => nil,
          "shipping" => nil,
          "application_fee" => nil,
          "refunds" => {
            "object" => "list",
            "total_count" => 0,
            "has_more" => false,
            "url" => "/v1/charges/ch_15z7EeJ1hgInCYPRdIjOlFDI/refunds",
            "data" => []
          },
          "statement_description" => "loveflix basic plan"
        }
      },
      "object" => "event",
      "pending_webhooks" => 1,
      "request" => "iar_6BUDouMqeV2OkW",
      "api_version" => "2014-08-04"
    }
  }

  let(:failed_event_data) {
    {
      "id" => "evt_160e7rJ1hgInCYPRDzf1fz2f",
      "created" => 1431201643,
      "livemode" => false,
      "type" => "charge.failed",
      "data" => {
        "object" => {
          "id" => "ch_160e7qJ1hgInCYPRtNuOITvd",
          "object" => "charge",
          "created" => 1431201642,
          "livemode" => false,
          "paid" => false,
          "status" => "failed",
          "amount" => 999,
          "currency" => "usd",
          "refunded" => false,
          "source" => {
            "id" => "card_160e7JJ1hgInCYPRxa6NzpHL",
            "object" => "card",
            "last4" => "0341",
            "brand" => "Visa",
            "funding" => "credit",
            "exp_month" => 5,
            "exp_year" => 2017,
            "fingerprint" => "TeLNW9B5KxdXUNP4",
            "country" => "US",
            "name" => nil,
            "address_line1" => nil,
            "address_line2" => nil,
            "address_city" => nil,
            "address_state" => nil,
            "address_zip" => nil,
            "address_country" => nil,
            "cvc_check" => "pass",
            "address_line1_check" => nil,
            "address_zip_check" => nil,
            "dynamic_last4" => nil,
            "metadata" => {},
            "customer" => "cus_6CE7g1yTd2Ohev"
          },
          "captured" => false,
          "card" => {
            "id" => "card_160e7JJ1hgInCYPRxa6NzpHL",
            "object" => "card",
            "last4" => "0341",
            "brand" => "Visa",
            "funding" => "credit",
            "exp_month" => 5,
            "exp_year" => 2017,
            "fingerprint" => "TeLNW9B5KxdXUNP4",
            "country" => "US",
            "name" => nil,
            "address_line1" => nil,
            "address_line2" => nil,
            "address_city" => nil,
            "address_state" => nil,
            "address_zip" => nil,
            "address_country" => nil,
            "cvc_check" => "pass",
            "address_line1_check" => nil,
            "address_zip_check" => nil,
            "dynamic_last4" => nil,
            "metadata" => {},
            "customer" => "cus_6CE7g1yTd2Ohev"
          },
          "balance_transaction" => nil,
          "failure_message" => "Your card was declined.",
          "failure_code" => "card_declined",
          "amount_refunded" => 0,
          "customer" => "cus_6CE7g1yTd2Ohev",
          "invoice" => nil,
          "description" => "",
          "dispute" => nil,
          "metadata" => {},
          "statement_descriptor" => nil,
          "fraud_details" => {},
          "receipt_email" => nil,
          "receipt_number" => nil,
          "shipping" => nil,
          "application_fee" => nil,
          "refunds" => {
            "object" => "list",
            "total_count" => 0,
            "has_more" => false,
            "url" => "/v1/charges/ch_160e7qJ1hgInCYPRtNuOITvd/refunds",
            "data" => []
          },
          "statement_description" => nil
        }
      },
      "object" => "event",
      "pending_webhooks" => 2,
      "request" => "iar_6D4Gi1uRUNI4Bi",
      "api_version" => "2014-08-04"
    }
  }

  context "when a charge is successful" do
    before do
      Fabricate(:user, email: email, stripe_id: stripe_id)
      post "/stripe_events", event_data
    end

    it "creates a new Payment object" do
      expect(Payment.count).to eq(1)
    end

    it "creates a new Payment with the correct amount" do
      expect(Payment.last.amount).to  eq(999)
    end

    it "creates a new Payment with the correct stripe_payment_id" do
      expect(Payment.last.stripe_payment_id).to  eq("ch_15z7EeJ1hgInCYPRdIjOlFDI")
    end

    it "creates a new Payment associated with the user" do
      user = Payment.last.user
      expect(user.stripe_id).to  eq(stripe_id)
      expect(user.email).to  eq(email)
    end
  end

  context "when a payment fails", :vcr do
    let!(:user) { Fabricate(:user, stripe_id: "cus_6CE7g1yTd2Ohev") }

    before do
      post "/stripe_events", failed_event_data
    end

    it "sets the user account as delinquent" do
      expect(user.reload).to be_delinquent
    end

    context "notifies the user via email" do
      let(:message) { ActionMailer::Base.deliveries.last }

      it "delivers email" do
        expect(ActionMailer::Base.deliveries).not_to be_empty
      end
      it "to the correct user" do
        expect(message.to.first).to  eq(user.email)
      end
      it "with correct content" do
        expect(message.body.raw_source).to include("Unfortunately something went wrong with your subscription payment")
      end
    end
  end

end