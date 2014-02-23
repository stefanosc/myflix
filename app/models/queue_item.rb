class QueueItem < ActiveRecord::Base
  belongs_to :video
  belongs_to :user

  validates_presence_of :user, :video
  validates_uniqueness_of :video, scope: :user

  delegate :category, to: :video
  delegate :title, to: :video, prefix: :video


  def rating
    review = self.video.reviews.where(user_id: self.user.id).first
    review.try(:rating)
  end

  def category_name
    category.name
  end

end
