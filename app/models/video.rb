class Video < ActiveRecord::Base
  
  include Sluggable

  sluggable_column :title

  belongs_to :category

end