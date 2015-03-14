require "spec_helper"

describe UsersController do

  describe "GET #new" do

    it "instantiate a new @user" do
      get :new
      expect(assigns(:user)).to be_new_record
    end
  end

  describe "GET 'new_with_invitation" do
    it "renders the :new template" do
      get :new_with_invitation, invite_token: "ljlkj"
      expect(response).to render_template('new')
    end

    it "instantiate a new @user instance" do
      get :new_with_invitation, invite_token: "lkhj"
      expect(assigns(:user)).to be_new_record
    end

    context "with valid invite_token" do
      context "and it has already been used" do
        let(:invite) { Fabricate(:invite) }
        before do
          Fabricate(:user, invite_token: invite.token )
          get :new_with_invitation, invite_token: invite.token
        end

        it "renders the used_token template" do
          expect(response).to render_template('used_token')
        end
      end

      context "and it has not been used" do
        let(:invite) { Fabricate(:invite) }
        before { get :new_with_invitation, invite_token: invite.token }

        it "pre populates @user.name" do
          expect(assigns(:user).name).to eq(invite.invitee_name)
        end
        it "pre populates @user.email" do
          expect(assigns(:user).email).to eq(invite.invitee_email)
        end
        it "pre populates @user.invite_token" do
          expect(assigns(:user).invite_token).to eq(invite.token)
        end
      end
    end

    context "with invalid invite_token" do
      it "sets a flash message" do
        get :new_with_invitation, invite_token: "lkhj"
        expect(flash[:success]).to be_present
      end
    end

  end

  describe "POST #create" do

    context "with a valid user but declined card" do
      let(:charge) { double('charge', successful?: false, error_message: "Card declined") }

      let(:user_attrs) { Fabricate.attributes_for(:user) }
      before do
        expect(StripeWrapper::Charge).to receive(:create) { charge }
        post :create,  user: user_attrs, stripeToken: "fake_token"
      end

      it "does NOT save the user to the database" do
        expect(User.count).to eq(0)
      end
      it "renders the :new template" do
        expect(response).to render_template :new
      end
      it "sets a flash error message" do
        expect(flash[:danger]).not_to be nil
      end
    end

    context "with a valid user" do
      let(:charge) { double('charge', successful?: true) }
      let(:user_attrs) { Fabricate.attributes_for(:user) }
      before do
        expect(StripeWrapper::Charge).to receive(:create) { charge }
        post :create,  user: user_attrs, stripeToken: "fake_token"
      end

      it "it saves the user to the database" do
        expect(User.count).to eq(1)
      end
      it "redirects to sign_in_path" do
        expect(response).to redirect_to sign_in_path
      end
      it "sets a flash success message" do
        expect(flash[:success]).not_to be nil
      end

      context 'sends welcome email' do
        let(:user_attrs) { Fabricate.attributes_for(:user) }
        before do
          post :create,  user: user_attrs, stripeToken: "fake_token"
        end

        it "delivers email" do
          expect(ActionMailer::Base.deliveries).not_to be_empty
        end
        it "to the correct user" do
          message = ActionMailer::Base.deliveries.last
          expect(message.to.first).to  eq(user_attrs[:email])
        end
        it "with correct content" do
          message = ActionMailer::Base.deliveries.last
          expect(message.parts[0].body.raw_source).to  include("Welcome to LoveFlix, we really appreciate")
        end
      end

      context "and the user was invited" do
        let(:charge) { double('charge', successful?: true) }
        let(:inviter) { Fabricate(:user) }
        let(:invite) { Fabricate(:invite, inviter_id: inviter.id) }
        before do
          expect(StripeWrapper::Charge).to receive(:create) { charge }
          password = Faker::Lorem.characters(10)
          post :create,  stripeToken: "fake_token",
                         user: { name:         invite.invitee_name,
                                 email:        invite.invitee_email,
                                 password:     password,
                                 invite_token: invite.token }
          @user = User.where(invite_token: invite.token).first
        end

        it "the user becomes follower of the inviter" do
          expect(@user.followers).to include(inviter)
        end

        it "the inviter becomes follower of the user" do
          expect(inviter.followers).to include(@user)
        end
      end
    end

    context "with an invalid user" do
      let(:user_attrs) { Fabricate.attributes_for(:user, name: "")}
      before do
        expect(StripeWrapper::Charge).not_to receive(:create)
        post :create,  user: user_attrs,
                       stripeToken: "fake_token"
      end

      it "does not create the user" do
        expect(User.count).to eq(0)
      end
      it "sets the @user instance" do
        expect(assigns(:user)).to be_instance_of(User)
      end
      it "renders the :new template" do
        expect(response).to render_template :new
      end
    end

  end

  describe "GET #show" do
    it_behaves_like "requires user to sign in" do
      let(:action) { get :show, id: "mark" }
    end

    it "sets @user variable to the requested user1" do
      set_current_user
      user1 = Fabricate(:user)
      get :show, id: user1.token
      expect(assigns(:user)).to eq user1
    end
  end

end
