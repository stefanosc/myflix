class Category < ActiveRecord::Base

  include Sluggable

  sluggable_column :name

  has_many :videos

  private
    
end