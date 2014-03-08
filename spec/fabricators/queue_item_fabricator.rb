Fabricator(:queue_item) do
  position { QueueItem.all.count +1 }
  video    { Fabricate(:video) }
  user     { Fabricate(:user) }
end
