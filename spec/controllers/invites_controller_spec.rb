require 'rails_helper'

RSpec.describe InvitesController, :type => :controller do

  describe "GET 'new'" do

    before { set_current_user }

    it "sets @invite to a new instance of Invite" do
      get :new
      expect(assigns(:invite)).to be_a_new(Invite)
    end
  end


  describe "GET 'create'" do

    before { set_current_user }

    context 'with valid attributes' do
      before do
        get :create, invite: { invitee_name: "Erik",
                               invitee_email: "erik@example.com",
                               message: "you will love this site dear Erik, \nlove"
                             }
      end
      it "redirects to new_invite_path" do
        expect(response).to redirect_to(people_path)
      end

      it "saves the invite details" do
        expect(Invite.all.size).to eq(1)
      end

      it "sets a flash[:success] message" do
        expect(flash[:success]).not_to be_nil
      end

      context 'sends an email' do
        it "to the invitee" do
          expect(ActionMailer::Base.deliveries).not_to be_empty
        end

        it "conatins the link to register with the token" do
          message = ActionMailer::Base.deliveries.last
          token = Invite.last.token
          expect(message.body.raw_source).to match(/\/register\/#{token}/)
        end
      end
    end

    context 'with invalid attributes' do
      before do
        get :create, invite: { invitee_name: "Erik",
                               invitee_email: "@example.com",
                               message: "you will love this site dear Erik, love"
                             }
      end

      it "renders the :new template" do
        expect(response).to render_template :new
      end
    end

    it_should_behave_like "requires user to sign in" do
      let(:action) { get :create }
    end
  end

end