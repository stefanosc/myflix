Fabricator(:queue_item) do
  position nil
  video    { Fabricate(:video) }
  user     { Fabricate(:user) }
end
