require 'spec_helper'

describe Category do
  it "saves itself" do
    c = Category.new(name: "test1", description: "the best Category")
    c.save
    expect(Category.first).to eq(c)
  end

  it "has many videos associated" do
    c = Category.create(name: "test1", description: "the best Category")
    v = Video.create(title: "first monk", description: "this is a monk movie", category: c)
    v1 = Video.create(title: "second monk", description: "this is a monk movie", category: c)
    expect(c.videos).to eq([v1, v])
  end 
end
