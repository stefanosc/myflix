Fabricator(:video) do
  title { Faker::Lorem.word + " movie" }
  description { Faker::Lorem.sentence(15) }
  category
end