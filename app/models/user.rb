class User < ActiveRecord::Base

  before_create :generate_token

  has_many :reviews
  has_many :queue_items, -> { order "position ASC" }
  has_many :followings
  has_many :followed_users, through: :followings
  has_many :following_followers, class_name: :Following, foreign_key: :followed_user_id
  has_many :followers, through: :following_followers, source: :user
  has_many :invites, foreign_key: :inviter_id

  has_secure_password validations: false
  validates_presence_of :name, :email
  validates_presence_of :password, on: :update, allow_blank: true
  validates_uniqueness_of :email, case_sensitive: false
  validates_length_of :password, within: 4..30, on: :update, allow_blank: true

  def normalize_queue_positions
    queue_items.each_with_index { |queue_item, i| queue_item.update(position: i+1 )}
  end

  def in_my_queue?(video)
    !queue_items.select { |queue_item| queue_item.video_id == video.id}.empty?
  end

  def to_param
    token
  end

  def generate_token
     self.token = SecureRandom.urlsafe_base64
  end
end