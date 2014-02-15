class AddReviewsCountToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :reviews_count, :integer, :default => 0

    Video.reset_column_information
    Video.all.each do |video|
      video.update(reviews_count: video.reviews.length)
    end
  end
end
