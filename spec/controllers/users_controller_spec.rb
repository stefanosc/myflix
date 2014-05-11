require "spec_helper"

describe UsersController do

  describe "GET #new" do

    it "instantiate a new @user" do
      get :new
      expect(assigns(:user)).to be_new_record
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

    it "sets @user variable" do
      set_current_user
      user1 = Fabricate(:user)
      get :show, id: user1.slug
      expect(assigns(:user)).to eq user1
    end
  end

  describe "GET #index" do

    it_behaves_like "requires user to sign in" do
      let(:action) { get :index }
    end

    it "sets the @followings of the current_user" do
      set_current_user
      users = []
      3.times {|i| users << Fabricate(:user)}
      current_user.followed_users = users
      get :index
      expect(assigns(:followings)).to eq(current_user.followings)
    end

  end

end
