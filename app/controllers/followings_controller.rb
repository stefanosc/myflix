class FollowingsController < UserAuthenticationController

  def index
    @followings = current_user.followings
  end

  def create

    if current_user.token == params[:token]
      flash[:danger] = "You can't follow yourself"
    else
      user = User.find_by(token: params[:token])
      following = current_user.followings.build(followed_user_id: user.try(:id) )

      if following.save
        flash[:success] = "You are now following #{params[:name]}"
      elsif following.errors.has_key?(:followed_user_id)
        flash[:danger] =  "You are already following #{params[:name]}"
      else
        flash[:danger] = "There was an error please try again later"
      end
    end

    redirect_to people_path
  end

  def destroy

    following = current_user.followings.find(params[:id]) if params[:id]
    following.destroy
    flash[:success] = "You have successuly unfollowed #{params[:name]}"
    redirect_to people_path
  end

end
