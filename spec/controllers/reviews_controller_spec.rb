require 'spec_helper'

describe ReviewsController do

  describe "POST #create" do

    let(:video) { video = Fabricate(:video) }

    context 'with authenticated user' do

      let(:current_user) { Fabricate(:user) }
      before {session[:user] = current_user.id }

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

    context 'with un-authenticated user' do

      it "redirects to the sing_in_path" do
        post :create, review: {rating: 5}, video_id: video.slug
        expect(response).to redirect_to sign_in_path
      end
    end
  end
end
