require 'spec_helper'

describe QueueItemsController do
  context 'when user is signed in' do
    let(:user) { Fabricate(:user) }
    before(:each) do
      session[:user] = user.id
    end

    describe "GET #index" do
      it "sets @queue_items" do
        get :index
        expect(assigns(:queue_items)).not_to be nil
      end
      it "sets @queue_items to the user queued items" do
        q = Fabricate(:queue_item, user: user)
        q1 = Fabricate(:queue_item, user: user)
        q2 = Fabricate(:queue_item, user: user)
        get :index
        expect(assigns(:queue_items)).to match_array([q,q1,q2])
      end
    end

  end

  context 'when user is NOT signed' do

    describe "GET #index" do
      it "redirects to the sign_in path" do
        get :index
        expect(response).to redirect_to sign_in_path
      end      
    end
    describe "POST #create" do
      it "redirects to the sign_in path" do
        post :create
        expect(response).to redirect_to sign_in_path
      end      
    end
    # describe "POST #update" do
    #   it "redirects to the sign_in path" do
    #     post :update, queue_item: 1
    #     expect(response).to redirect_to sign_in_path
    #   end
    # end
    # describe "POST #destroy" do
    #   it "redirects to the sign_in path" do
    #     post :destroy
    #     expect(response).to redirect_to sign_in_path
    #   end 
    # end

  end


end
