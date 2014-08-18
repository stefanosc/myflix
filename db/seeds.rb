# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

video_path = [ "http://loveflix.s3.amazonaws.com/video/HW2%20Solution.mp4",
               "http://loveflix.s3.amazonaws.com/video/HW2%20set%20up%20unicorn%20and%20sidekiq%20on%20production.mp4"
             ]

%w(Action Sci-Fi Fantasy).each do |category|
  description = "In this category you will find the most beautiful #{category.downcase} movies"
  p Category.create(name: category, description: description)
end

Dir.glob('public/images/video/small_cover/*.jpg').sort.each do |image|
  p movie_title = File.basename(image,'.jpg').gsub('_', ' ').titleize
  p movie_thumbnail = File.basename(image)
  categories = Category.all
  video = Video.create(title: movie_title,
              description: "#{movie_title} is just awesome. Enjoy your membership",
              category_id: categories[rand(3)].id,
              video_url: video_path.sample
              )
  p video.update_columns(small_cover: movie_thumbnail, large_cover: "monk_large.jpg")
end

users = []
users << mark = User.create(name: "Mark Jacob", email: "mark@example.com", password: "mark")
users << kelly = User.create(name: "Kelly Jones", email: "kelly@example", password: "kelly")
users << stefano = User.create(name: "Stefano Schiavi", email: "stefano@bvprojects.org", password: "stefano", admin: true)

Video.all.each do |video|
  review = ["I quite like this movie", "This movie was fantastic", "It was ok", "Best movie ever"]
  users.each do |user|
    Review.create(user: user, video: video, body: review[rand(4)], rating: rand(5)+1 )
  end
end