require 'spec_helper'

describe Video do

  it { should belong_to(:category)}

  it { should validate_presence_of(:description)}
  it { should validate_presence_of(:title)}
  it { should validate_presence_of(:category)}

  describe ".search_by_title" do
    it "searches by title and returns empty array if not found" do
      c = Category.create(name: "monk category", description: "category description")
      v = Video.create(title: "this is a Monk movie", description: "this is the monk description", category: c )
      expect(Video.search_by_title('not here')).to eq([])
    end

    it "searches by title and returns an array of matches" do
      c = Category.create(name: "monk category", description: "category description")
      v = Video.create(title: "this is a monk movie", description: "this is the monk description", category: c )
      expect(Video.search_by_title('monk')).to eq([v])
    end

    it "searches by title regardless of case and returns an array of matches" do
      c = Category.create(name: "monk category", description: "category description")
      v = Video.create(title: "this is a Monk movie", description: "this is the monk description", category: c )
      expect(Video.search_by_title('monk')).to eq([v])
    end

    it "returns an empty array if searched for empty string" do
      c = Category.create(name: "monk category", description: "category description")
      v = Video.create(title: "this is a Future movie", description: "this is the future description", category: c )
      expect(Video.search_by_title('')).to eq([])   
    end

    it "returns an array of matches ordered by created_at" do
      c = Category.create(name: "monk category", description: "category description")
      v = Video.create(title: "this is a Monk movie", description: "this is the monk description", category: c, created_at: 1.day.ago )
      v1 = Video.create(title: "this is a Future movie", description: "this is the future description", category: c )
      expect(Video.search_by_title('movie')).to eq([v1, v])         
    end
  end

  describe ".search_by_title_categorized" do
    it "returns search results in a hash categorized" do
      c1 = Category.create(name: "future", description: "category description")
      c2 = Category.create(name: "adventure", description: "category description")
      c3 = Category.create(name: "love", description: "category description")
      v6 = Video.create(title: "futurama friends", description: "this is the monk description", category: c1, created_at: 1.day.ago )
      v5 = Video.create(title: "almost human friends", description: "this is the monk description", category: c1, created_at: 2.day.ago )
      v4 = Video.create(title: "friends adventure", description: "this is the monk description", category: c2, created_at: 3.day.ago )
      v3 = Video.create(title: "trekking friends", description: "this is the monk description", category: c2, created_at: 4.day.ago )
      v2 = Video.create(title: "love friends", description: "this is the monk description", category: c3, created_at: 5.day.ago )
      v1 = Video.create(title: "romance friends", description: "this is the future description", category: c3 )
      expect(Video.search_by_title_categorized("friends")).to eq({c1 => [v6,v5], c2 => [v4,v3], c3 => [v1,v2]})
    end

  end

end
