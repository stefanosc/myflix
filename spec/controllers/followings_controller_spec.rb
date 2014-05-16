require "spec_helper"

describe FollowingsController do

  before {set_current_user}

  describe "POST #create" do

    it_behaves_like "requires user to sign in" do
      let(:action) { post :create }
    end

    context 'with a valid user id' do

      let(:user1) { Fabricate(:user) }
      before do
        post :create, id: user1.id, name: user1.name
      end

      it "adds the selected user to current_user followed_users" do
        expect(current_user.followed_users.first).to eql(user1)
      end

      it "sets a flash message" do
        expect(flash[:success]).not_to be_nil
      end

      it "it redirects to the people page" do
        expect(request).to redirect_to people_path
      end
    end

    context 'when user is trying to follow him/her self' do
      it "does not save the following" do
        post :create, id: current_user.id, name: current_user.name
        expect(Following.all.count).to eq(0)
      end
    end

    context 'with invalid user id' do

      before do
        post :create
      end

      it "does not add to current_user followed_users" do
        expect(current_user.followed_users).to be_empty
      end

      it "sets a flash message" do
        expect(flash[:danger]).not_to be_nil
      end
      it "it redirects to the people page" do
        expect(request).to redirect_to people_path
      end

    end

  end

  describe "DELETE #destroy" do
    it_behaves_like "requires user to sign in" do
      let(:action) { post :create }
    end

    context 'with a valid user id' do

      let(:user1) { Fabricate(:user) }
      before do
        current_user.followed_users << user1
        delete :destroy, id: current_user.followings.first.id
      end

      it "destroyes the requested current_user.following" do
        expect(current_user.followed_users).to be_empty
      end
      it "sets a flash message" do
        expect(flash[:success]).not_to be_nil
      end
      it "redirects to the people page" do
        expect(response).to redirect_to(people_path)
      end
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
