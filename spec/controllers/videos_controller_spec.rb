require "spec_helper"

describe VideosController do
  subject { Fabricate(:video) } 

  describe "GET #show" do
    it "assigns the requested video to @video" do
      get :show, id: 1
      expect(subject).to  eq(video)
    end
    it "renders the :show template" do

    end
  end

  describe "GET #search" do
    it "assigns the search term to @q" do
      
    end
    it "it assigns the result as an array of arrays in blocks of 6 to @videos" do
      
    end
    it "renders the :search template" do
      
    end
  end

end