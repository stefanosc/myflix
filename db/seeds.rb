# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Category.delete_all
Video.delete_all
User.delete_all
Review.delete_all

%w(Action Sci-Fi Fantasy).each do |category|
  description = "In this category you will find the most beautiful #{category.downcase} movies"
  Category.create(name: category, description: description)
end

Dir.glob('public/tmp/*.jpg').sort.each do |image|
  unless image.match("large")
    movie_title = File.basename(image,'.jpg').gsub('_', ' ').titleize 
    movie_thumbnail = image.gsub('public', '')
  end
  categories = Category.all
  video = Video.create(title: movie_title, 
              description: "#{movie_title} is just awesome. Enjoy your membership", 
              small_cover_url: movie_thumbnail, 
              large_cover_url: "/tmp/monk_large.jpg", 
              category_id: categories[rand(3)].id )
end

users = []
users << mark = User.create(name: "Mark Jacob", email: "mark@example.com", password: "mark")
users << kelly = User.create(name: "Kelly Jones", email: "kelly@example", password: "kelly")
users << stefano = User.create(name: "Stefano Schiavi", email: "stefano@bvprojects.org", password: "stefano")

Video.all.each do |video|
  review = ["I quite like this movie", "This movie was fantastic", "It was ok", "Best movie ever"]
  users.each do |user|
    Review.create(user: user, video: video, body: review[rand(4)], rating: rand(5)+1 )
  end
end