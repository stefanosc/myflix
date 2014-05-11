require "spec_helper"

describe Following do
  it { should belong_to(:user) }
  it { should belong_to(:followed_user) }
  it { should validate_presence_of(:followed_user_id) }
  it { should validate_uniqueness_of(:followed_user_id).scoped_to(:user_id) }
end