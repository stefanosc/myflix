class AddPasswordTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :password_reset, :string
    add_column :users, :password_reset_created_at, :datetime
  end
end
