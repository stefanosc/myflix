require "spec_helper"
Capybara.default_wait_time = 10

feature "user registration", { vcr: true, js: true } do
  let(:valid_user_attrs) { Fabricate.attributes_for(:user) }
  let(:invalid_user_attrs) { Fabricate.attributes_for(:user, email: "") }
  let(:valid_card) { { number: "4242424242424242" } }
  let(:declined_card) { { number: "4000000000000002" } }
  let(:incorrect_card) { { number: "4000000000000099" } }
  background do
    visit register_path
  end


  scenario "with a valid user and credit card" do
    register(valid_user_attrs, valid_card)
    expect(page).to have_text("Thank you for signing up")
  end

  scenario "with a valid user and incorrect credit card" do
    register(valid_user_attrs, incorrect_card)
    expect(page).to have_text("Your card number is incorrect.")
  end

  scenario "with a valid user and declined credit card" do
    register(valid_user_attrs, declined_card)
    expect(page).to have_text("Your card was declined")
  end

  scenario "with an invalid user and valid credit card" do
    register(invalid_user_attrs, valid_card)
    expect(page).to have_text("Please fix the errors below.")
  end

  scenario "with an invalid user and incorrect credit card" do
    register(invalid_user_attrs, incorrect_card)
    expect(page).to have_text("Your card number is incorrect.")
  end

  scenario "with an invalid user and declined credit card" do
    register(invalid_user_attrs, declined_card)
    expect(page).to have_text("Please fix the errors below.")
  end
end


def register(user_attrs, card)
  fill_in 'Email Address', with: user_attrs[:email]
  fill_in 'Password', with: user_attrs[:password]
  fill_in 'Full Name', with: user_attrs[:name]
  fill_in "Credit Card Number",  with: card[:number]
  fill_in "Security Code",  with: "123"
  select('12 - December', :from => 'date_month')
  select('2017', :from => 'date_year')
  click_on 'Sign Up'
end

  # expect(page).to have_text("Sign in")
  # fill_in 'Email', with: user_attrs[:email]
  # fill_in 'Password', with: user_attrs[:password]
  # click_button 'Sign in'
