class CreateFollowing < ActiveRecord::Migration
  def change
    create_table :followings do |t|
      t.integer :user_id, index: true
      t.integer :followed_user_id, index: true
      t.timestamps
    end
  end
end
