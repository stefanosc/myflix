class Video < ActiveRecord::Base
  
  include Sluggable

  sluggable_column :title

  belongs_to :category
  has_many :reviews

  validates_presence_of :title, :description, :category

  def self.search_by_title(search_term)
    return [] if search_term == "" || search_term == nil
    where('title LIKE ?', "%#{search_term}%").order("created_at DESC")
  end

  def self.search_by_title_categorized(search_term)
    raw_results = self.search_by_title(search_term)
    raw_results.reduce({}) do |collection, video|
      if collection[video.category].nil?
        collection[video.category] = []
        collection[video.category] << video
      else
        collection[video.category] << video        
      end
      collection
    end
  end

  def recent_reviews
    reviews.order('created_at DESC').limit(10)
  end


end