class Category < ActiveRecord::Base

  include Sluggable

  sluggable_column :name

  has_many :videos,  -> {order('created_at desc')}

  def recent_videos
    videos.first(6)
  end

  private
    
end