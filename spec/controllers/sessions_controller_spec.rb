require "spec_helper"

describe SessionsController do

  describe "GET #new" do
    it "sets the session referer if the session referer is nil" do
      request.env["HTTP_REFERER"] = "some_path"
      post :new
      expect(session[:referer]).to be_true
    end
    it "does not reset the referer if it is not nil" do
      session[:referer] = "some_path"
      post :new
      expect(session[:referer]).to eq("some_path")
    end
    it "redirects to home if user is already logged in" do
      session[:user] = Fabricate(:user).id
      post :new
      expect(response).to  redirect_to(home_path)
    end
  end

  describe "POST #create" do

    context "when user signs in with valid credentials" do
      let(:alice) { Fabricate(:user) } 
      before do
        post :create, email: alice.email, password: alice.password        
      end
      it "sets the session[:user] to the current_user" do
        expect(session[:user]).to eq(alice.id)
      end
      it "it sets the flash[:success]" do
        expect(flash[:success]).not_to be_blank                  
      end
      it "clears the session referer" do
        expect(session[:referer]).to  be_nil
      end
    end

    context "when signed in with valid credentials session[:refer]" do
      let(:alice) { Fabricate(:user) } 

      it "redirects to home_path when set to nil" do
        session[:referer] = nil
        post :create, email: alice.email, password: alice.password        
        expect(response).to redirect_to(home_path)
      end
      it "redirects to home_path when set to sign_in_path" do
        session[:referer] = sign_in_path
        post :create, email: alice.email, password: alice.password        
        expect(response).to redirect_to(home_path)
      end
      it "redirects to home_path when set to root_path" do
        session[:referer] = root_path
        post :create, email: alice.email, password: alice.password        
        expect(response).to redirect_to(home_path)
      end
      it "redirects to current value when not root / home / sign_in path" do
        session[:referer] = "/some/path"
        post :create, email: alice.email, password: alice.password        
        expect(response).to redirect_to("/some/path")
      end    
    end

    context "when user signs in with invalid credentials" do
      let(:alice) { Fabricate(:user) } 
      before do
        post :create, email: alice.email, password: alice.password + "he"
      end

      it "does not set the user id in the session" do
        expect(session[:user]).to be_blank  
      end
      it "sets flash.now[:danger]" do
        expect(flash.now[:danger]).not_to be_blank          
      end
      it "it renders the login page again" do
        expect(response).to  render_template :new
      end
    end
  
  end

  describe "GET #destroy" do
    let(:user)  { Fabricate(:user) } 

    before(:each) do
      session[:user] = user.id
      get :destroy
    end

    it "clears the session user" do
      expect(session[:user]).to  be_nil
    end
    it "redirects to root path" do
      expect(response).to  redirect_to(root_path)
    end
    it "sets flassh success" do
      expect(flash[:success]).not_to be_blank
    end
  end

end
