require 'rails_helper'

RSpec.describe Invite, :type => :model do

  it { should belong_to(:inviter) }

  it_behaves_like "tokenable" do
    let(:object) { Fabricate(:invite) }
  end

end
