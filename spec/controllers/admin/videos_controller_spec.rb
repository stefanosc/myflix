require 'rails_helper'

RSpec.describe Admin::VideosController, :type => :controller do
  before { set_current_user admin: true }

  it_behaves_like "requires user to sign in" do
    let(:action) { get :new }
  end
  it_behaves_like "requires user to be admin" do
    let(:action) { get :new }
  end

  describe "GET 'new'" do
    it "sets @video to a new instance of Video" do
      get :new
      expect(assigns(:video)).to be_a_new(Video)
    end
  end

  describe "POST 'create'" do

    context 'with valid attributes' do
      before do
        # small_cover = File.new(Rails.root + "public/tmp/thor_dark_world.jpg")
        # large_cover = File.new(Rails.root + "public/tmp/monk_large.jpg")
        post :create, video: { title: "Thor Dark World",
                              category_id: ( Fabricate(:category).id ),
                              description: "This is a cool action movie",
                              # large_cover: ActionDispatch::Http::UploadedFile.new(
                              #   tempfile: large_cover,
                              #   filename: File.basename(large_cover),
                              #   type: "image/jpeg"),
                              # small_cover: ActionDispatch::Http::UploadedFile.new(
                              #   tempfile: small_cover,
                              #   filename: File.basename(small_cover),
                              #   type: "image/jpeg")
                            }
      end
      it "redirects to new_admin_video_path" do
        expect(response).to redirect_to(new_admin_video_path)
      end

      it "saves the video details" do
        expect(Video.all.size).to eq(1)
      end

      it "sets a flash[:success] message" do
        expect(flash[:success]).not_to be_nil
      end

    end

    context 'with invalid attributes' do
      before do
        post :create, video: { title: "Thor Dark World",
                      description: "This is a cool action movie" }
      end

      it "renders the :new template" do
        expect(response).to render_template :new
      end
      it "sets the @video variable" do
        expect(assigns(:video)).to be_truthy
      end
      it "renders the :new template" do
        expect(flash[:danger]).not_to be_nil
      end
      it "renders the :new template" do
        expect(Video.all.count).to eq(0)
      end
    end
  end
end
