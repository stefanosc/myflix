Fabricator(:review) do
  body   { Faker::Lorem.sentence(25) }
  rating { rand(5) + 1 }
end
