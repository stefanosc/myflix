require 'spec_helper'

describe User do
  
  it { should have_many(:queue_items) } 
  it { should have_many(:reviews) } 
  it { should validate_presence_of(:password) }

  describe "#in_my_queue?" do
    let(:video1) { Fabricate(:video) }
    let(:video2) { Fabricate(:video) }
    let(:user) { Fabricate(:user) }
    before { Fabricate(:queue_item, video: video2, user: user) }

    it "returns true if the video is in the user queue_items" do
      expect(user.in_my_queue?(video2)).to be_true 
    end
    it "returns false if the video is not in the user queue_items" do
      expect(user.in_my_queue?(video1)).to be_false
    end
  end


end