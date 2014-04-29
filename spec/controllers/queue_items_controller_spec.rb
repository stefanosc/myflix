require 'spec_helper'

describe QueueItemsController do

  before { set_current_user }

  describe "GET #index" do

    context 'when user is signed in' do

      it "sets @queue_items" do
        get :index
        expect(assigns(:queue_items)).not_to be nil
      end

      it "sets @queue_items to the user queued items" do
        q = Fabricate(:queue_item, user: current_user)
        q1 = Fabricate(:queue_item, user: current_user)
        q2 = Fabricate(:queue_item, user: current_user)
        get :index
        expect(assigns(:queue_items)).to match_array([q,q1,q2])
      end
    end

    it_behaves_like "requires user to sign in"  do
      let(:action) { get :index }
    end
  end

  describe "POST #create" do
    context 'user is signed in' do

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
          queue_item = current_user.queue_items.first
          expect(queue_item.video).to eq(video)
        end
        it "creates a QueueItem associated with current_user" do
          post :create, video_slug: video.slug
          queue_item = current_user.queue_items.first
          expect(queue_item.user).to eq(current_user)
        end
        it "creates the QueueItem and sets it as last position" do
          video1 = Fabricate(:video)
          queue_item = QueueItem.create(user: current_user, video: video1, position: 1)
          post :create, video_slug: video.slug
          queue_item_last = QueueItem.find_by(video: video)
          expect(queue_item_last.position).to eq(2)
        end
        it "does not create a new queue_item if the video is already in user queue" do
          queue_item = QueueItem.create(user: current_user, video: video, position: 1)
          post :create, video_slug: video.slug
          expect(current_user.queue_items.count).to eq(1)
        end
        it "sets flash message when video is already in user queue" do
          queue_item = QueueItem.create(user: current_user, video: video, position: 1)
          post :create, video_slug: video.slug
          expect(flash[:danger]).not_to be nil
        end
        it "redirects back to the queue_items_path when the video is already in the user queue" do
          queue_item = QueueItem.create(user: current_user, video: video, position: 1)
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

    it_behaves_like "requires user to sign in"  do
      let(:action) { post :create }
    end
  end




  describe "POST #update_queue" do
    context 'when user is signed in' do

      context 'with valid attributes' do

        let(:queue_item1) { Fabricate(:queue_item, user: current_user, position: 1) }
        let(:queue_item2) { Fabricate(:queue_item, user: current_user, position: 2) }
        let(:queue_item3) { Fabricate(:queue_item, user: current_user, position: 3) }

        it "it redirects to the queue_items_path" do
          post :update_queue, queue_items: [{id: queue_item1.id, position: 3}, {id: queue_item2.id, position: 1}, {id: queue_item3.id, position: 2}]
          expect(response).to redirect_to queue_items_path
        end
        it "updates the order of the queue items" do
          post :update_queue, queue_items: [{id: queue_item1.id, position: 3}, {id: queue_item2.id, position: 1}, {id: queue_item3.id, position: 2}]
          expect(current_user.queue_items).to  eq([queue_item2, queue_item3, queue_item1])
        end
        it "normazlizes the position numbers" do
          post :update_queue, queue_items: [{id: queue_item1.id, position: 6}, {id: queue_item2.id, position: 5}, {id: queue_item3.id, position: 2}]
          expect(current_user.queue_items.map(&:position)).to  eq([1, 2, 3])
        end
      end
      context 'with invalid attributes' do

        let(:queue_item1) { Fabricate(:queue_item, user: current_user, position: 1) }
        let(:queue_item2) { Fabricate(:queue_item, user: current_user, position: 2) }

        it "redirects to queue_items_path" do
          post :update_queue, queue_items: [{id: queue_item1.id, position: 6}, {id: queue_item2.id, position: 2.2}]
          expect(response).to redirect_to queue_items_path
        end
        it "it sets a flash message" do
          post :update_queue, queue_items: [{id: queue_item1.id, position: 6}, {id: queue_item2.id, position: 2.2}]
          expect(flash[:danger]).to be_present
        end
        it "does not update the queue items position" do
          post :update_queue, queue_items: [{id: queue_item1.id, position: 6}, {id: queue_item2.id, position: 2.2}]
          expect(queue_item1.reload.position).to  eq(1)
          expect(queue_item2.reload.position).to  eq(2)
        end
      end

      context 'when queue items do not belong to current user' do
        let(:user1) { Fabricate(:user) }
        let(:queue_item1) { Fabricate(:queue_item, user: user1, position: 1) }
        let(:queue_item2) { Fabricate(:queue_item, user: user1, position: 2) }

        it "does not update the queue items position" do
          post :update_queue, queue_items: [{id: queue_item1.id, position: 6}, {id: queue_item2.id, position: 5}]
          expect(queue_item1.reload.position).to eq 1
        end
        it "sets a flash[:danger] message" do
          post :update_queue, queue_items: [{id: queue_item1.id, position: 6}, {id: queue_item2.id, position: 5}]
          expect(flash[:danger]).to be_present
        end
      end
    end

    it_behaves_like "requires user to sign in"  do
      let(:action) { post :update_queue, queue_items: [{id: 1, position: 6}, {id: 2, position: 5}] }
    end
  end

  describe "DELETE #destroy" do
    context 'user is signed in' do

      it "it destroys the QueueItem obj requested" do
        queue_item = Fabricate(:queue_item, user: current_user)
        delete :destroy, id: queue_item.id
        expect(QueueItem.count).to eq(0)
      end
      it "does not destroy the QueueItem obj if current user is not the owner" do
        queue_item1 = Fabricate(:queue_item)
        delete :destroy, id: queue_item1.id
        expect(QueueItem.count).to eq(1)
      end
      it "it redirects to back to the queue_items_path" do
        queue_item = Fabricate(:queue_item, user: current_user)
        delete :destroy, id: queue_item.id
        expect(response).to redirect_to queue_items_path
      end
      it "normalizes the remaining queue items" do
        queue_item1 = Fabricate(:queue_item, user: current_user, position: 1)
        queue_item2 = Fabricate(:queue_item, user: current_user, position: 2)
        queue_item3 = Fabricate(:queue_item, user: current_user, position: 3)
        delete :destroy, id: queue_item2.id
        expect(current_user.queue_items.map(&:position)).to  eq([1, 2])
      end
    end

    it_behaves_like "requires user to sign in"  do
      let(:action) { delete :destroy, id: "1" }
    end
  end

end