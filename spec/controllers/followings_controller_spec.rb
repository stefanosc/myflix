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
        expect(request).to redirect_to users_path
      end

      context 'when user is already following the other user' do
        it "sets a different flash message" do
          expect(flash[:danger]).not_to eq("You already follow #{user1.name}")
        end
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
        expect(request).to redirect_to users_path
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
        expect(response).to redirect_to(users_path)
      end
    end
  end
end
