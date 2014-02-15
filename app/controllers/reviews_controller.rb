class ReviewsController < ApplicationController
  before_action :require_user

  def create
    @video = Video.find_by(slug: params[:video_id])
    @review = @video.reviews.build(params.require(:review).permit(:body, :rating).merge!({user: current_user}))
    if @review.save
      redirect_to @video
    else
      @reviews = @video.reviews.reload
      render 'videos/show'
    end
  end
end 