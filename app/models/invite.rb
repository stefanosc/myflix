class Invite < ActiveRecord::Base

  include Tokenable

  belongs_to :inviter, class_name: :User

  validates_presence_of :inviter_id, :invitee_name, :invitee_email, :message
  validates :invitee_email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, on: :create }

end
