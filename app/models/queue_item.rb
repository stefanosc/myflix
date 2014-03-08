class QueueItem < ActiveRecord::Base
  belongs_to :video
  belongs_to :user

  validates_presence_of :user_id, :video_id
  validates_uniqueness_of :video_id, scope: :user_id
  validates_numericality_of :position, only_integer: true

  delegate :category, to: :video
  delegate :title, to: :video, prefix: :video


  def rating
    review = video.reviews.where(user_id: user.id).first
    review.try(:rating)
  end

  def category_name
    category.name
  end

end
