Fabricator(:invite) do
  inviter_id    { Fabricate(:user).id }
  invitee_email { Faker::Internet.email }
  invitee_name { Faker::Name.name }
  message { Faker::Lorem.paragraph(10) }
end
