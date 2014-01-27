class Video < ActiveRecord::Base
  
  include Sluggable

  sluggable_column :title

  belongs_to :category

  validates_presence_of :title, :description, :category

end