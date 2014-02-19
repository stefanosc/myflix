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

    describe "POST #create" do
      context 'with valid attributes' do
        before do
          video = Fabricate(:video)
          post :create, video_slug: video.slug
        end
        it "creates a new QueueItem instance" do
          expect(QueueItem.count).to eq(1)
        end
        it "redirects to the queue_items_path" do
          expect(response).to redirect_to queue_items_path 
        end      
      end

      context 'with invalid attributes' do
        before do
          post :create, video_slug: "a"
        end

        it "does not create a QueueItem instance" do
          expect(QueueItem.count).to eq(0)
        end
        it "sets a flash alert message" do
          expect(flash[:danger]).not_to be nil
        end
        it "redirects_to the video_path that made the request" do
          expect(response).to redirect_to video_path 
        end
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
    describe "POST #update" do
      it "redirects to the sign_in path" do
        post :update, use_route: :queue_items, queue_item: 1
        expect(response).to redirect_to sign_in_path
      end
    end
    describe "POST #destroy" do
      it "redirects to the sign_in path" do
        post :destroy, use_route: :queue_items
        expect(response).to redirect_to sign_in_path
      end 
    end

  end


end
