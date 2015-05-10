Fabricator(:user) do
  name { Faker::Name.name }
  email { Faker::Internet.email }
  password { Faker::Lorem.characters(10) }
end

Fabricator(:admin, from: :user) do
  admin { true }
end