require "spec_helper"

describe VideosController do

  let(:video) { Fabricate(:video) }
  let(:user) { Fabricate(:user) }

  describe "GET #show" do
    context 'when user is signed in' do

      it "assigns the requested video to @video" do
        session[:user] = user.id
        get :show, id: video
        expect(assigns(:video)).to  eq(video)
      end
      it "assigns the requested video reviews to @reviews" do
        session[:user] = user.id
        get :show, id: video
        review1 = Fabricate(:review, video: video, user: user)
        review2 = Fabricate(:review, video: video)
        expect(assigns(:reviews)).to  include(review2, review1)
      end

    end
  end

  describe "GET #search" do

    let(:user) { Fabricate(:user)}

    it "redirects un-authenticated users to sign_in page" do
      get :search
      expect(response).to redirect_to sign_in_path
    end
    it "assigns the search term to @q" do
      session[:user] = user.id
      get :search, q: "family"
      expect(assigns(:q)).to eq("family")
    end
    it "assigns the result as @videos" do
      session[:user] = user.id
      matrix = Fabricate(:video, title: "matrix")
      get :search, q: "mat"
      expect(assigns(:videos)).to eq([matrix])
    end
    it "if there are more than 6 results it only loads the first 6 videos" do
      session[:user] = user.id
      matrix = Fabricate(:video, title: "matrix")
      count = 1
      6.times do
        Fabricate(:video, title: "matrix_#{count}")
        count += 1
      end
      get :search, q: "mat"
      expect(assigns(:videos)).not_to include(matrix)
    end
    it "if there are no search results it returns empty array" do
      session[:user] = user.id
      matrix = Fabricate(:video, title: "matrix")
      get :search, q: "love"
      expect(assigns(:videos)).to eq([])
    end
  end
end
