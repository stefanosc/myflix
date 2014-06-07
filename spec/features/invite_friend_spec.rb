require "spec_helper"

feature "Password Reset" do
  let(:user) { Fabricate(:user) }
  let(:friend_attrs) { Fabricate.attributes_for(:user) }
  background do
    clear_emails
  end

  scenario "user resets password" do
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
  click_on 'Sign Up'
  fill_in 'email', with: friend_attrs[:email]
  fill_in 'password', with: friend_attrs[:password]
  click_button 'Sign in'
end

