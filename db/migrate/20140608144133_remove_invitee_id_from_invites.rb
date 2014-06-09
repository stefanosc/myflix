class RemoveInviteeIdFromInvites < ActiveRecord::Migration
  def change
    remove_column :invites, :invitee_id
  end
end
