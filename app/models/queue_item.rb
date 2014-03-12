class QueueItem < ActiveRecord::Base
  belongs_to :video
  belongs_to :user

  validates_presence_of :user_id, :video_id
  validates_uniqueness_of :video_id, scope: :user_id
  validates_numericality_of :position, only_integer: true

  delegate :category, to: :video
  delegate :title, to: :video, prefix: :video

  def rating
    review.try(:rating)
  end

  def rating= (rating)
    if review 
      review.update_attribute(:rating, rating)
    else
      review = Review.new(video_id: video_id,
                          user_id: user_id,
                          rating: rating )
      review.save(validate: false)
    end
  end

  def category_name
    category.name
  end

  def review
    Review.where(user_id: user_id, video_id: video_id).first
  end

end
