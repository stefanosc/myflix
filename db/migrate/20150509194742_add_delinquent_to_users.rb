class AddDelinquentToUsers < ActiveRecord::Migration
  def change
    add_column :users, :delinquent, :boolean, default: false
  end
end
