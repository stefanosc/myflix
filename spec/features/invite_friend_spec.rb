require "spec_helper"

feature "Invite Friend" do
  let(:user) { Fabricate(:user) }
  let(:friend_attrs) { Fabricate.attributes_for(:user) }
  background do
    clear_emails
  end

  scenario "user invites friends and friend signs up", { vcr: true, js: true } do
    user_sends_invitation

    friend_opens_email_registers_sign_in
    visit people_path

    expect(page).to have_content("#{user.name}")

    visit sign_out_path
    sign_in(user)
    visit people_path

    expect(page).to have_content("#{friend_attrs[:name]}")
  end

end

def user_sends_invitation
  sign_in(user)
  visit people_path
  click_on 'Invite a friend'
  fill_in "Friend's Email Address", with: friend_attrs[:email]
  fill_in "Friend's Name", with: friend_attrs[:name]
  fill_in "Invitation Message", with: Faker::Lorem.paragraph(1)
  click_on 'Send Invitation'
end

def friend_opens_email_registers_sign_in
  open_email(friend_attrs[:email])
  current_email.find(:xpath, "//a[contains(@href, 'register')]").click
  fill_in 'Password', with: friend_attrs[:password]
  fill_in "Credit Card Number",  with: "4242424242424242"
  fill_in "Security Code",  with: "123"
  select('12 - December', :from => 'date_month')
  select('2017', :from => 'date_year')
  click_on 'Sign Up'
  sleep 8
  fill_in 'Email', with: friend_attrs[:email]
  fill_in 'Password', with: friend_attrs[:password]
  click_button 'Sign in'
end

