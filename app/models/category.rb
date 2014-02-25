class Category < ActiveRecord::Base

  include Sluggable

  sluggable_column :name

  has_many :videos,  -> {order('created_at desc')}

  validates_presence_of :name

  def recent_videos
    videos.first(6)
  end

end
