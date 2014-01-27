class Video < ActiveRecord::Base
  
  include Sluggable

  sluggable_column :title

  belongs_to :category

  validates_presence_of :title, :description, :category

  def self.search_by_title(search_term)
    return [] if search_term == ""
    where('title LIKE ?', "%#{search_term}%").order("created_at DESC")
  end

end