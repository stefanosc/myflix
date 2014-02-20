class QueueItemsController < ApplicationController

  before_action :require_user

  def index
    @queue_items = current_user.my_queue_items
  end

  def create
    video = Video.find_by(slug: params[:video_slug])
    queue_item = QueueItem.new(video: video, user: current_user)
    if queue_item.save
      redirect_to queue_items_path
    else
      flash[:danger] = "There was a problem with your queue request or the video is already in your queue"
      redirect_to ( video ? video : home_path )
    end
  end

  def update
    
  end

  def destroy

  end

end
