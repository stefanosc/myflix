def set_current_user
  user = Fabricate(:user)
  session[:user] = user.id
end

def current_user
  User.find(session[:user])
end

def clear_current_user
  session[:user] = nil
end