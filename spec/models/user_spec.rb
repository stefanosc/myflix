require 'spec_helper'

describe User do

  it { should have_many(:queue_items) }
  it { should have_many(:reviews) }
  it { should have_many(:following_followers) }
  it { should have_many(:followers) }
  it { should have_many(:followings) }
  it { should have_many(:followed_users) }
  it { should have_many(:invites) }
  it { should have_many(:payments) }

  describe "#in_my_queue?" do
    let(:video1) { Fabricate(:video) }
    let(:video2) { Fabricate(:video) }
    let(:user) { Fabricate(:user) }
    before { Fabricate(:queue_item, video: video2, user: user) }

    it "returns true if the video is in the user queue_items" do
      expect(user.in_my_queue?(video2)).to be true
    end
    it "returns false if the video is not in the user queue_items" do
      expect(user.in_my_queue?(video1)).to be false
    end
  end

  it_behaves_like "tokenable" do
    let(:object) { Fabricate(:user) }
  end

end