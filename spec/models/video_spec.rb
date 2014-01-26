require 'spec_helper'

describe Video do
  it "saves itself" do
    c = Category.create(name: "test1", description: "the best Category")    
    v = Video.new(title: "first monk", description: "this is a monk movie", category: c, small_cover_url: "/tmp/monk.jpg", large_cover_url: "/tmp/monk_large.jpg")
    v.save
    Video.first.title.should == "first monk"
  end

  it "belongs to a category" do
    c = Category.create(name: "test1", description: "the best Category")
    v = Video.create(title: "test video category", description: "this is a monk movie", category: c, small_cover_url: "/tmp/monk.jpg", large_cover_url: "/tmp/monk_large.jpg")
    expect(Video.first.category).to eq(c)
  end

  it "fails validation with no title" do
    expect(Video.create).to have(1).errors_on(:title)
  end

  it "fails validation with no category" do
    expect(Video.create).to have(1).errors_on(:category)
  end

  it "fails validation with no description" do
    expect(Video.create).to have(1).errors_on(:description)
    expect(Video.count).to eq(0)
  end

  it "passes validation with on title" do
    expect(Video.create(title: "Monk")).to have(0).errors_on(:title)
  end

  it "fails validation with no category" do
    c = Category.create(name: "test1", description: "the best Category")
    expect(Video.create(category: c) ).to have(0).errors_on(:category)
  end

  it "fails validation with no description" do
    expect(Video.create(description: "the best movie") ).to have(0).errors_on(:description)
  end

end
