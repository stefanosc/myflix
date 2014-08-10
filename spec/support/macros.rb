def set_current_user(opts={})
  user = Fabricate(:user, admin: opts[:admin])
  session[:user] = user.id
end

def current_user
  User.find(session[:user])
end

def clear_current_user
  session[:user] = nil
end

def sign_in(user, password_modifier="")
  visit sign_in_path
  fill_in 'email', with: user.email
  fill_in 'password', with: user.password + password_modifier
  click_button 'Sign in'
end

def visit_video_and_follow_user(video_slug, user_name)
  visit home_path
  find(:xpath, "//a[@href='/videos/#{video_slug}']").click
  click_on user_name
  click_on "Follow"
end