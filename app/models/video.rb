class Video < ActiveRecord::Base

  include Sluggable

  sluggable_column :title

  belongs_to :category
  has_many :reviews, -> { order 'created_at DESC'}
  has_many :queue_items

  validates_presence_of :title, :description, :category

  def self.search_by_title(search_term)
    return [] if search_term == "" || search_term == nil
    where('title LIKE ?', "%#{search_term}%").order("created_at DESC")
  end

  def recent_reviews
    reviews.limit(10)
  end


end