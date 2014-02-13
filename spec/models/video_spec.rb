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
      expect(Video.search_by_title('movie').first).to eq(v1)         
    end

  end

  describe "#recent_reviews" do
    before(:all) do
      @movie = Fabricate(:video)
      8.times {Fabricate(:review, video: @movie, created_at: 6.days.ago)}
      @review1 = Fabricate(:review, video: @movie, created_at: 1.day.ago)
      @review2 = Fabricate(:review, video: @movie, created_at: 2.day.ago)
      @review3 = Fabricate(:review, video: @movie, created_at: 3.day.ago)
      @review4 = Fabricate(:review, video: @movie, created_at: 4.day.ago)
    end

    it "loads in reviews reverse cronological order" do
      expect(@movie.recent_reviews.first(4)).to  eq([@review1, @review2, @review3, @review4])
    end
    it "limits to the first 10 reviews" do
      expect(@movie.recent_reviews.count).to  eq(10)
    end
  end

end
