require 'spec_helper'

describe QueueItemsController do

  describe "GET #index" do

    context 'when user is signed in' do

      let(:user) { Fabricate(:user) }
      before { session[:user] = user.id }

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

    context 'user is not signed in' do

      it "redirects to the sign_in path" do
        get :index
        expect(response).to redirect_to sign_in_path
      end
    end
  end


  describe "POST #create" do
    context 'user is signed in' do

      let(:user) { Fabricate(:user) }
      before { session[:user] = user.id }

      context 'with valid attributes' do

        let(:video) { Fabricate(:video) }

        it "creates a new QueueItem instance" do
          post :create, video_slug: video.slug
          expect(QueueItem.count).to eq(1)
        end
        it "redirects to the queue_items_path" do
          post :create, video_slug: video.slug
          expect(response).to redirect_to queue_items_path
        end
        it "creates a QueueItem associated with current video" do
          post :create, video_slug: video.slug
          queue_item = user.queue_items.first
          expect(queue_item.video).to eq(video)
        end
        it "creates a QueueItem associated with current_user" do
          post :create, video_slug: video.slug
          queue_item = user.queue_items.first
          expect(queue_item.user).to eq(user)
        end
        it "creates the QueueItem and sets it as last position" do
          video1 = Fabricate(:video)
          queue_item = QueueItem.create(user: user, video: video1)
          post :create, video_slug: video.slug
          queue_item_last = QueueItem.find_by(video: video)
          expect(queue_item_last.position).to eq(2)
        end
        it "does not create a new queue_item if the video is already in user queue" do
          queue_item = QueueItem.create(user: user, video: video)
          post :create, video_slug: video.slug
          expect(user.queue_items.count).to eq(1)
        end
        it "sets flash message when video is already in user queue" do
          queue_item = QueueItem.create(user: user, video: video)
          post :create, video_slug: video.slug
          expect(flash[:danger]).not_to be nil
        end
        it "redirects back to the queue_items_path when the video is already in the user queue" do
          queue_item = QueueItem.create(user: user, video: video)
          post :create, video_slug: video.slug
          expect(response).to redirect_to queue_items_path
        end

      end

      context 'with invalid attributes' do
        before { post :create, video_slug: "a" }

        it "does not create a QueueItem instance" do
          expect(QueueItem.count).to eq(0)
        end
        it "sets a flash alert message" do
          expect(flash[:danger]).not_to be nil
        end
        it "redirects_to the video_path that made the request" do
          expect(response).to redirect_to home_path
        end
      end
    end

    context 'user is not signed in' do
      it "redirects to the sign_in path" do
        post :create
        expect(response).to redirect_to sign_in_path
      end
    end
  end




  describe "POST #update" do
    context 'user is signed in' do

    end

    context 'user is not signed in' do
      it "redirects to the sign_in path" do
        patch :update, id: "1"
        expect(response).to redirect_to sign_in_path
      end
    end
  end

  describe "DELETE #destroy" do
    context 'user is signed in' do

      let(:user) { Fabricate(:user) }
      before { session[:user] = user.id }

      it "it destroys the QueueItem obj requested" do
        queue_item = Fabricate(:queue_item, user: user)
        delete :destroy, id: queue_item.id
        expect(QueueItem.count).to eq(0)
      end
      it "does not destroy the QueueItem obj if current user is not the owner" do
        queue_item1 = Fabricate(:queue_item)
        delete :destroy, id: queue_item1.id
        expect(QueueItem.count).to eq(1)
      end
      it "it redirects to back to the queue_items_path" do
        queue_item = Fabricate(:queue_item, user: user)
        delete :destroy, id: queue_item.id
        expect(response).to redirect_to queue_items_path
      end
    end

    context 'user is not signed in' do
      it "redirects to the sign_in path" do
        delete :destroy, id: "1"
        expect(response).to redirect_to sign_in_path
      end
    end
  end


end
