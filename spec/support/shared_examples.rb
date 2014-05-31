shared_examples "requires user to sign in" do
  it "redirects to sign_in_path when user is not signed in" do
    clear_current_user
    action
    expect(response).to redirect_to sign_in_path
  end
end

shared_examples "redirects to invalid token page with invalid token" do
  it "renders the token invalid page" do
    action
    expect(response).to render_template("pages/invalid_token")
  end
end
