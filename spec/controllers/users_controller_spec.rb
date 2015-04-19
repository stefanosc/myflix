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

    context "when signup fails" do
      let(:signup) { double('signup', successful?: false, error_message: nil) }

      let(:user_attrs) { Fabricate.attributes_for(:user) }
      before do
        expect(UserSignup).to receive(:new) { signup }
        post :create,  user: user_attrs, stripeToken: "fake_token"
      end

      it { is_expected.to render_template :new }

      it "sets the @user instance" do
        expect(assigns(:user)).to be_instance_of(User)
      end

      context "when signup sets error_message" do
        let(:signup) { double('signup', successful?: false, error_message: "some credit card error message") }
        before do
          expect(UserSignup).to receive(:new) { signup }
          post :create,  user: user_attrs, stripeToken: "fake_token"
        end

        it { is_expected.to set_flash[:danger] }
      end

    end

    context "when signup is successful" do
      let(:signup) { double('signup', successful?: true, success_message: "success") }
      let(:user_attrs) { Fabricate.attributes_for(:user) }
      before do
        expect(UserSignup).to receive(:new) { signup }
        post :create,  user: user_attrs, stripeToken: "good_token"
      end

      it { is_expected.to set_flash[:success] }

      it "redirects to sign_in_path" do
        expect(response).to redirect_to sign_in_path
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
