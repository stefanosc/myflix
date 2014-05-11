class UsersController < ApplicationController
  before_action :set_user, only: [:show]
  before_action :require_user, only: [:show]
  
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      flash[:success] = "You have successfully registered"
      redirect_to sign_in_path
    else
      render :new
    end
  end

  def show
  end

  private

  def set_user
    @user = User.find_by_slug(params[:id]) if params[:id]
  end

  def user_params
    params.require(:user).permit(:name, :email, :password)
  end

end
