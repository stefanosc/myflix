class ReviewsController < ApplicationController
  before_action :require_user

  def create
    @video = Video.find_by(slug: params[:video_id])
    @review = @video.reviews.build(review_params.merge!({user: current_user}))
    if @review.save
      redirect_to @video
    else
      @reviews = @video.reviews.reload
      render 'videos/show'
    end
  end

  def destroy

    review = Review.find(params[:review])
    if review.user == current_user
      review.delete
    else
      flash[:danger] = "You can only delete reviews you created"
    end
    redirect_to queue_items_path
  end

  private

  def review_params
    params.require(:review).permit(:body, :rating)
  end
end 
