require 'spec_helper'

describe ReviewsController do

  describe "POST #create" do
    context 'with authenticated user' do
      context 'with valid input' do

        let(:current_user) { Fabricate(:user) }
        before {session[:user] = current_user.id }

        it "redirects to the video page" do
          video = Fabricate(:video)
          post :create, review: Fabricate.attributes_for(:review), video_id: video.slug
          expect(response).to redirect_to video_path(video)
        end
        it "saves the review to the db" do
          video = Fabricate(:video)
          post :create, review: Fabricate.attributes_for(:review), video_id: video.slug
          expect(Review.count).to eq(1)
        end
        it "saves a review associated with the video" do
          video = Fabricate(:video)
          post :create, review: Fabricate.attributes_for(:review), video_id: video.slug
          expect(Review.first.video).to eq(video)
        end
        it "saves a review associated with the current user" do
          video = Fabricate(:video)
          post :create, review: Fabricate.attributes_for(:review), video_id: video.slug
          expect(Review.first.user).to eq(current_user)
        end
        # it "sets a success flash notice" do
        #   video = Fabricate(:video)
        #   post :create, review: Fabricate.attributes_for(:review), video_id: video.slug
        # end
      end

      context 'with in-valid input' do
        let(:current_user) { Fabricate(:user) }
        before {session[:user] = current_user.id }

        it "does not save the review to the db" do
          video = Fabricate(:video)
          post :create, review: {rating: 5}, video_id: video.slug
          expect(Review.count).to eq(0)
        end
        it "renders the video page" do
          video = Fabricate(:video)
          post :create, review: {rating: 5}, video_id: video.slug
          expect(response).to render_template 'videos/show' 
        end
        it "displays an error message" do

        end
      end
    end

    context 'with un-authenticated user' do
      it "redirects to the sing_in_path" do
        video = Fabricate(:video)
        post :create, review: {rating: 5}, video_id: video.slug
        expect(response).to redirect_to sign_in_path 
      end
    end
  end
end
