class Invite < ActiveRecord::Base

  before_create :generate_token

  belongs_to :inviter, class_name: :User

  validates_presence_of :inviter_id, :invitee_name, :invitee_email, :message
  validates :invitee_email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, on: :create }

  def generate_token
     self.token = SecureRandom.urlsafe_base64
  end
end
