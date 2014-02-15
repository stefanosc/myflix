class Review < ActiveRecord::Base
  belongs_to :video
  belongs_to :user
  validates :video, presence: true
  validates :user, presence: true
  validates :body, presence: true
  validates :rating, presence: true
  
end
