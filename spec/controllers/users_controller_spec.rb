require "spec_helper"

describe UsersController do

  describe "GET #new" do

    it "instantiate a new @user" do
      get :new
      expect(assigns(:user)).to be_new_record
    end

    context "when invite_token is present" do
      let(:invite) { Fabricate(:invite) }
      before { get :new, invite_token: invite.token }

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

  describe "POST #create" do

    context "with a valid user" do

      let(:user) { Fabricate.attributes_for(:user) }
      before { post :create,  user: user }

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
        let(:user) { Fabricate.attributes_for(:user) }
        before { post :create,  user: user }

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
        let(:inviter) { Fabricate(:user) }
        let(:invite) { Fabricate(:invite, inviter_id: inviter.id) }
        before do
          password = Faker::Lorem.characters(10)
          post :create,  user: { name: invite.invitee_name,email: invite.invitee_email, password: password, invite_token: invite.token }
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
      let(:user) { Fabricate.attributes_for(:user, name: "")}
      before do
        post :create,  user: user
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
