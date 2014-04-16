require 'spec_helper'

describe ReviewsController do

  before { set_current_user }

  describe "POST #create" do

    let(:video) { video = Fabricate(:video) }

    context 'with authenticated user' do

      context 'with valid input' do
        before { post :create, review: Fabricate.attributes_for(:review), video_id: video.slug }

        it "redirects to the video page" do
          expect(response).to redirect_to video_path(video)
        end
        it "saves the review to the db" do
          expect(Review.count).to eq(1)
        end
        it "saves a review associated with the video" do
          expect(Review.first.video).to eq(video)
        end
        it "saves a review associated with the current user" do
          expect(Review.first.user).to eq(current_user)
        end
      end

      context 'with in-valid input' do

        it "does not save the review to the db" do
          post :create, review: {rating: 5}, video_id: video.slug
          expect(Review.count).to eq(0)
        end
        it "renders the video/show template" do
          post :create, review: {rating: 5}, video_id: video.slug
          expect(response).to render_template 'videos/show'
        end
        it "sets the @video variable" do
          review = Fabricate(:review, video: video)
          post :create, review: {rating: 5}, video_id: video.slug
          expect(assigns(:video)).to eq(video)
        end
        it "sets the @reviews variable" do
          review = Fabricate(:review, video: video)
          post :create, review: {rating: 5}, video_id: video.slug
          expect(assigns(:reviews)).to match_array([review])
        end
      end
    end

    it_behaves_like "requires user to sign in"  do
      let(:action) {post :create, review: {rating: 5}, video_id: video.slug}
    end
  end

  describe "POST #destroy" do
    context 'with authenticated user' do

      context 'when current_user == review.user' do
        let(:review) { Fabricate(:review, user: current_user) }

        it "redirects to the queue_items_path" do
          post :destroy, review: review.id
          expect(response).to redirect_to queue_items_path
        end
        it "destroys the review passed via params" do
          post :destroy, review: review.id
          expect(Review.all.count).to eq 0
        end

      end

      context 'when current_user != review.user' do
        let(:review) { Fabricate(:review) }

        it "redirects to the queue_items_path" do
          post :destroy, review: review.id
          expect(response).to redirect_to queue_items_path
        end
        it "does not destroy the review passed via params" do
          post :destroy, review: review.id
          expect(Review.all.count).to eq 1
        end
        it "sets a flash[:danger] message" do
          post :destroy, review: review.id
          expect(flash[:danger]).to  be_present
        end
      end
    end

    it_behaves_like "requires user to sign in"  do
      let(:action) { post :destroy, id: 1 }
    end
  end
end
˚∫
