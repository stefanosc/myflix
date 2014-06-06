require 'rails_helper'

RSpec.describe Invite, :type => :model do

  it { should belong_to(:inviter) }

end
