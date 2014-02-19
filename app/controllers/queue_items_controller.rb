class QueueItemsController < ApplicationController

  before_action :require_user

  def index
    @queue_items = user_queue(current_user)
  end

  def create
    video = Video.find_by(slug: params[:video_slug])
    queue_item = QueueItem.new(video: video, user: current_user)
    require 'pry'; binding.pry
    if queue_item.save
      redirect_to queue_items_path
    else
      flash[:danger] = "There was a problem with your queue request or the video is already in your queue"
      redirect_to video
    end
  end

  def update
    
  end

  def destroy

  end

  private

  def user_queue(user) 
    user.queue_items.includes(video: [:category, :reviews]).where('reviews.user_id' => [nil, user.id])
  end

end
