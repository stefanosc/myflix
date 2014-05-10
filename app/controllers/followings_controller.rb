class FollowingsController < ApplicationController
  before_filter :require_user

  def create

    following = current_user.followings.build(followed_user_id: params[:id] )

    if following.save
      flash[:success] = "You are now following #{params[:name]}"
    elsif following.errors.has_key?(:followed_user_id)
      flash[:danger] =  "You are already following #{params[:name]}"
    else
      flash[:danger] = "There was an error please try again later"
    end

    redirect_to users_path
  end

  def destroy

    following = current_user.followings.find(params[:id]) if params[:id]
    following.destroy
    flash[:success] = "You have successuly unfollowed #{params[:name]}"
    redirect_to users_path
  end

end
