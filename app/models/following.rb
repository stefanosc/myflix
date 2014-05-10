class Following < ActiveRecord::Base

  belongs_to :user
  belongs_to :followed_user, class_name: :User

  validates_presence_of :followed_user_id
  validates_uniqueness_of :followed_user_id, scope: :user_id


end