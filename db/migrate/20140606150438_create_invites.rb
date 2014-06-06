class CreateInvites < ActiveRecord::Migration
  def change
    create_table :invites do |t|
      t.string :token
      t.integer :inviter_id
      t.integer :invitee_id
      t.string :invitee_email
      t.string :invitee_name
      t.text :message
      t.timestamps
    end
  end
end
