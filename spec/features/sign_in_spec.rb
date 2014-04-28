require "spec_helper"

feature "sign in" do
  let(:user) { Fabricate(:user)}

  scenario "Signing in with correct credentials" do
    sign_in(user)
    expect(page).to have_content "Welcome, #{user.name}"
  end

  scenario "Signing in with invalid credentials" do
    sign_in(user, "hello")
    expect(page).to have_content 'The Email and Password combination you entered does not match'
  end

end