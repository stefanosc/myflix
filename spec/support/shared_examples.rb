shared_examples "requires user to sign in" do
  it "redirects to sign_in_path when user is not signed in" do
    clear_current_user
    action
    expect(response).to redirect_to sign_in_path
  end
end

shared_examples "requires user to be admin" do
  it "redirects to root_path when signed in user is not admin" do
    clear_current_user
    set_current_user
    action
    expect(response).to redirect_to root_path
  end
end

shared_examples "redirects to invalid token page with invalid token" do
  it "renders the token invalid page" do
    action
    expect(response).to redirect_to(invalid_token_path)
  end
end

shared_examples "tokenable" do
  it "generates a new random token when the object is created" do
    expect(object.token).to be_present
  end
end