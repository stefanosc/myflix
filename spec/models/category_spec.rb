require 'spec_helper'

describe Category do

  it { should have_many(:videos)}
  it { should validate_presence_of(:name) }

  describe "#recent_videos" do
    it "returns all if less than 6 videos mathcing" do
      c = Category.create!(name: "monk category", description: "category description")
      v1 = Video.create!(title: "this is a Monk 1 movie", description: "this is the monk description", category: c, created_at: 8.day.ago )
      v2 = Video.create!(title: "this is a Monk 2 movie", description: "this is the monk description", category: c, created_at: 7.day.ago )
      v3 = Video.create!(title: "this is a Monk 3 movie", description: "this is the monk description", category: c, created_at: 6.day.ago )
      v4 = Video.create!(title: "this is a Monk 4 movie", description: "this is the monk description", category: c, created_at: 5.day.ago )      
      expect(c.recent_videos).to eq([v4, v3, v2, v1])
    end

    it "returns 6 videos if more than 6 videos mathcing" do
      c = Category.create!(name: "monk category", description: "category description")
      v = Video.create!(title: "this is a Monk 1 movie", description: "this is the monk description", category: c, created_at: 8.day.ago )
      6.times { Video.create!(title: "this is a Monk 2 movie", description: "this is the monk description", category: c ) }
      expect(c.recent_videos).not_to include(v)
    end

    it "returns recent videos in desc created_at order" do
      c = Category.create!(name: "monk category", description: "category description")
      v = Video.create!(title: "this is a Monk 1 movie", description: "this is the monk description", category: c, created_at: 8.day.ago )
      6.times { Video.create!(title: "this is a Monk 2 movie", description: "this is the monk description", category: c, created_at: 9.day.ago ) }
      expect(c.recent_videos.first).to eq(v)
    end


    it "returns empty array if no videos mathcing" do
      c = Category.create!(name: "monk category", description: "category description")
      expect(c.recent_videos).to eq([]) 
    end

  end

end
