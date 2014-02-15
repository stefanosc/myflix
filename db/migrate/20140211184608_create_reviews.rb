class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.text :body
      t.integer :rating
      t.references :video, index: true
      t.references :user, index: true

      t.timestamps
    end
  end
end
