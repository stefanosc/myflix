# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

6.times do
  Video.create(title: "Monk", 
              description: "This is the best monk movie. Enjoy your membership", 
              small_cover_url: "public/tmp/monk.jpg", 
              large_cover_url: "public/tmp/monk_large.jpg")

  Video.create(title: "Family Guy", 
              description: "This is the best Family Guy movie. Enjoy your membership", 
              small_cover_url: "public/tmp/family_guy.jpg", 
              large_cover_url: "public/tmp/monk_large.jpg")

end