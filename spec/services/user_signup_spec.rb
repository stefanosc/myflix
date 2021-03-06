require 'spec_helper'

RSpec.describe UserSignup do

  context "with a valid user but declined card" do
    let(:customer) { double('customer', successful?: false, error_message: "Card declined") }

    let(:user) { Fabricate.build(:user) }
    before do
      expect(StripeWrapper::Customer).to receive(:create) { customer }
      UserSignup.new(user: user,
                     charge_token: "fake_token",
                     invite_token: nil).signup!
    end

    it "does NOT save the user to the database" do
      expect(User.count).to eq(0)
    end
  end

  context "with a valid user" do
    let(:customer) { double('customer', successful?: true, stripe_id: "stubbed_id") }
    let(:user) { Fabricate.build(:user) }
    before do
      expect(StripeWrapper::Customer).to receive(:create) { customer }
      UserSignup.new(user: user,
                     charge_token: "fake_token",
                     invite_token: nil).signup!
    end

    it "saves the user to the database" do
      expect(User.count).to eq(1)
    end

    it "saves the stripe customer as stripe_id" do
      expect(User.last.stripe_id).to  eq("stubbed_id")
    end

    context 'sends welcome email' do
      let(:user) { Fabricate.build(:user) }
      before do
        expect(StripeWrapper::Customer).to receive(:create) { customer }
        UserSignup.new(user: user, charge_token: "fake_token", invite_token: nil).signup!
      end

      it "delivers email" do
        expect(ActionMailer::Base.deliveries).not_to be_empty
      end
      it "to the correct user" do
        message = ActionMailer::Base.deliveries.last
        expect(message.to.first).to  eq(user[:email])
      end
      it "with correct content" do
        message = ActionMailer::Base.deliveries.last
        expect(message.parts[0].body.raw_source).to  include("Welcome to LoveFlix, we really appreciate")
      end
    end

    context "and the user was invited" do
      let(:customer) { double('customer', successful?: true, stripe_id: "stubbed_id") }
      let(:inviter) { Fabricate(:user) }
      let(:invite) { Fabricate(:invite, inviter_id: inviter.id) }
      let(:invited_user) { Fabricate.build(:user,
                                            name:     invite.invitee_name,
                                            email:    invite.invitee_email,
                                            password: "pass") }
      before do
        expect(StripeWrapper::Customer).to receive(:create) { customer }
        UserSignup.new(user: invited_user,
                       charge_token: "fake_token",
                       invite_token: invite.token).signup!
      end

      it "the user becomes follower of the inviter" do
        expect(invited_user.followers).to include(inviter)
      end

      it "the inviter becomes follower of the user" do
        expect(inviter.followers).to include(invited_user)
      end
    end
  end

  context "with an invalid user" do
    let(:invalid_user) { Fabricate.build(:user, name: "")}
    before do
      expect(StripeWrapper::Charge).not_to receive(:create)
      UserSignup.new(user: invalid_user,
                     charge_token: "fake_token",
                     invite_token: nil).signup!
    end

    it "does not create the user" do
      expect(User.count).to eq(0)
    end
  end

end