require 'spec_helper'

describe VideoDecorator do
  let(:video) { Fabricate(:video) }
  let(:video_with_no_reviews) { Fabricate(:video) }
  let(:review) { Fabricate(:review, rating: 4, video: video) }
  let(:review1) { Fabricate(:review, rating: 2, video: video) }
  let(:avg_rating) { ((review.rating + review1.rating) / 2.0).round(1) }

  describe '#rating' do
    context "when the video has reviews" do
      it "returns the average of the video ratings" do
        expect("rating #{avg_rating} / 5.0").to  eq(video.decorate.rating)
      end
    end

    context "when the video has no reviews" do
      it "returns a string inviting user to rate" do
        expect(video_with_no_reviews.decorate.rating).to  eq("Be the first one to review")
      end
    end
  end

end
