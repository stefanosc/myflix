require 'spec_helper'

describe Review do

  it { should belong_to(:user) } 
  it { should belong_to(:video) }
  it { should validate_presence_of(:video) } 
  it { should validate_presence_of(:user) } 
  it { should validate_presence_of(:body) } 
  it { should validate_presence_of(:rating) } 

  describe "#recent_reviews" do
    it "loads the 10 most recent reviews" do
      Fabricate.times(8, :review)
      review4 = Fabricate(:review, created_at: 4.days.ago)
      review3 = Fabricate(:review, created_at: 3.days.ago)
      review2 = Fabricate(:review, created_at: 2.days.ago)
      review1 = Fabricate(:review, created_at: 1.days.ago)

    end
    it "it loads review in revers chronological order" do
      
    end
  end

end
