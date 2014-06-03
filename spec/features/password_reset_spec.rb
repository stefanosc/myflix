require "spec_helper"

feature "Password Reset" do
  let(:user) { Fabricate(:user) }

  background do
    clear_emails
  end

  scenario "user resets password" do
    visit sign_in_path
    click_on 'Forgot Password?'
    fill_in 'email', with: user.email
    click_on 'Send Email'

    open_email("#{user.email}")
    current_email.find(:xpath, "//a[contains(@href, '#{user.password_reset}')]").click
    fill_in 'password', with: "hello"
    click_on 'Update Password'

    fill_in 'Email Address', with: user.email
    fill_in 'Password', with: "hello"
    click_on 'Sign in'

    expect(page).to have_content("Welcome, #{user.name}")
  end

end
