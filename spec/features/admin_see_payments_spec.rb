require 'rails_helper'

RSpec.feature "AdminSeePayments", type: :feature do

  let(:user) { Fabricate(:user) }
  let!(:payment) { Fabricate(:payment, user: user) }

  scenario 'admins see the payments' do
    admin = Fabricate(:admin)
    sign_in(admin)
    visit admin_payments_path
    expect(page).to  have_content(payment.stripe_payment_id)
  end

  scenario 'users get redirected to home page' do
    sign_in(user)
    visit admin_payments_path
    expect(page.current_path).not_to  eq(admin_payments_path)
    expect(page).to  have_content("You are not authorized to access this page")
  end
end
