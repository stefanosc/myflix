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
      before do
        post :create,  user: user        
      end

      it "redirects to sign_in_path if the @user is saved" do
        expect(User.count).to eq(1)
      end
      it "redirects to sign_in_path" do
        expect(response).to redirect_to sign_in_path
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
end
