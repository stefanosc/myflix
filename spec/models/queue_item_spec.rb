require 'spec_helper'

describe QueueItem do

  it { should belong_to(:video) } 
  it { should belong_to(:user) } 
  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:video_id) }

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

  describe "#rating=" do
    let(:user) { Fabricate(:user) }
    let(:video) { Fabricate(:video, title: "love") }
    let(:queue_item) { Fabricate(:queue_item, video: video, user: user) }

    it "updates the review rating when the review is present" do
      review = Fabricate(:review, user: user, video: video, rating: 2)
      queue_item.rating = 4
      expect(queue_item.reload.rating).to eq(4)
    end
    it "does not change the rating when the rating is not between (1..5) " do
      review = Fabricate(:review, user: user, video: video, rating: 2)
      queue_item.rating = nil
      expect(queue_item.reload.rating).to eq(2)
    end
    it "creates a new review and set the rating when the review is not present" do
      queue_item.rating = 4
      expect(queue_item.reload.rating).to eq(4)
    end
    it "does not create a review when the rating is not between (1..5) " do
      queue_item.rating = 0
      expect(queue_item.video.reviews.count).to eq(0)
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
