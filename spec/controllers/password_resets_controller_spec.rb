require 'spec_helper'

describe PasswordResetsController do

  describe "POST #create" do

    context "when the user is identified by the email" do
      let(:user) { Fabricate(:user) }
      before { post :create, email: user.email }

      it "generates a token for the user" do
        expect(user.reload.password_reset).not_to be_nil
      end

      it "sends an email" do
        expect(ActionMailer::Base.deliveries).not_to be_empty
      end

      it "sends an email to the user" do
        message = ActionMailer::Base.deliveries.last
        expect(message.to).to eq([user.email])
      end

      it "sends an email with a link to the user token" do
        message = ActionMailer::Base.deliveries.last
        expect(message.body).to include(user.reload.password_reset)
      end

      it "renders the password reset confirmation page" do
        expect(response).to redirect_to("pages/confirm_password_reset")
      end

    end

    context "when no user is found by the email" do
      before { post :create }

      it "sets a flash danger message" do
        expect(flash[:danger]).not_to be_nil
      end

      it "renders the new action" do
        expect(response).to render_template(:new)
      end
    end
  end

  describe "GET #edit" do

    context "when a user matches a valid password reset token" do
      let(:user) { Fabricate(:user) }
      before do
        user.update(password_reset: SecureRandom.urlsafe_base64, password_reset_created_at: Time.now - 29.minutes)
        get :edit, password_reset: user.password_reset
      end

      it "sets the @user variable to the matched user" do
        expect(assigns(:user)).to eq(user)
      end
    end

    it_should_behave_like "redirects to invalid token page with invalid token" do
      let(:action) { get :edit, password_reset: "jjjjjjj" }
    end
  end

  describe "PATCH #update" do

    context "when a user matches a valid password reset token" do
      let(:user) { Fabricate(:user) }
      before do
        user.update(password_reset: SecureRandom.urlsafe_base64, password_reset_created_at: Time.now - 29.minutes)
      end

      it "sets the @user variable to the matched user" do
        patch :update, password_reset: user.password_reset
        expect(assigns(:user)).to eq(user)
      end

      context 'when the user updates with valid password' do
        before { patch :update, password_reset: user.password_reset,
                                password: "newpass" }
        it "sets a flash[:success] message" do
          expect(flash[:success]).not_to be_nil
        end

        it "redirects to the sign_in_path" do
          expect(response).to redirect_to(sign_in_path)
        end
      end

      context 'when the user updates with invalid password' do
        before { patch :update, password_reset: user.password_reset,
                                password: "not" }
        it "sets a flash[:danger] message" do
          expect(flash[:danger]).not_to be_nil
        end

        it "renders the edit page" do
          expect(response).to render_template('edit')
        end
      end
    end

    it_should_behave_like "redirects to invalid token page with invalid token" do
      let(:action) { patch :update, password_reset: "jjjjjjj" }
    end
  end

end
