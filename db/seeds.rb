# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

12.times do
  Video.create(title: "Monk", 
              description: "This is the best monk movie. Enjoy your membership", 
              small_cover_url: "/tmp/monk.jpg", 
              large_cover_url: "/tmp/monk_large.jpg", category_id: 2)

  Video.create(title: "Family Guy", 
              description: "This is the best Family Guy movie. Enjoy your membership", 
              small_cover_url: "/tmp/family_guy.jpg", 
              large_cover_url: "/tmp/monk_large.jpg", category_id: 1)

end

category = ["Love", "Action", "Sci-Fi", "Fantasy"]

4.times do |i|
  c = Category.new 
  c.name = category[i]
  c.description = "In this category you will find the most beautiful #{category[i].downcase} movies"
  c.save
end

i = 1

Video.all.each do |v|
  v.category_id = i
  v.save
  i+=1
  if i > 4
    i = 1
  end 
end