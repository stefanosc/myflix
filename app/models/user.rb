class User < ActiveRecord::Base

  include Sluggable 

  sluggable_column :name
  has_many :reviews
  has_many :queue_items, -> { order "position ASC" }

  has_secure_password validations: false
  validates_presence_of :password, :name, :email
  validates_uniqueness_of :email, case_sensitive: false
  validates_length_of :password, within: 4..30, on: :update, allow_blank: true

  def normalize_queue_positions
    queue_items.each_with_index { |queue_item, i| queue_item.update(position: i+1 )}
  end

end