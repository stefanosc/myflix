class QueueItem < ActiveRecord::Base
  belongs_to :video
  belongs_to :user

  validates_presence_of :user, :video
  validates_uniqueness_of :video, scope: :user

end
