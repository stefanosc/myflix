require 'spec_helper'

describe QueueItem do

  it { should belong_to(:video) } 
  it { should belong_to(:user) } 
  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:video) }

  describe "#video_title" do
    it "returns the title of the video associated" do
      video = Fabricate(:video, title: "love")
      queue_item = Fabricate(:queue_item, video: video)
      expect(queue_item.video_title).to eq("love")
    end 
  end

  describe "#rating" do
    let(:user) { Fabricate(:user) }
    let(:video) { Fabricate(:video, title: "love") }
    let(:queue_item) { Fabricate(:queue_item, video: video, user: user) }

    it "returns the rating of the user review is present" do
      review = Fabricate(:review, video: video, rating: 5, user: user)
      expect(queue_item.rating).to eq(5)
    end
    it "returns nil if user has no reviews for video" do
      expect(queue_item.rating).to be nil
    end
  end

  describe "#category_name" do
    let(:category) { Fabricate(:category, name: "love") }
    let(:video) { Fabricate(:video, category: category) }
    let(:queue_item) { Fabricate(:queue_item, video: video) }
    
    it "returns the category name of the video associated" do
      expect(queue_item.category_name).to eq("love")
    end

  end

  describe "#category" do
    let(:category) { Fabricate(:category, name: "love") }
    let(:video) { Fabricate(:video, category: category) }
    let(:queue_item) { Fabricate(:queue_item, video: video) }
    
    it "returns the category object of the video associated" do
      expect(queue_item.category).to eq(category) 
    end
  end
end
