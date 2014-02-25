class QueueItemsController < ApplicationController

  before_action :require_user

  def index
    @queue_items = current_user.queue_items
  end

  def create
    video = Video.find_by(slug: params[:video_slug])
    queue_item = QueueItem.new(video: video, user: current_user, position: queue_item_last_position )
    if queue_item.save
      redirect_to queue_items_path
    elsif video.nil?
      flash[:danger] = "Are you trying to be naughty? :) Pleae use the browser"
      redirect_to home_path
    else
      flash[:danger] = "this video is already in your queue"
      redirect_to queue_items_path
    end
  end

  def update

  end

  def destroy
    queue_item =  QueueItem.find(params[:id])
    if queue_item.user == current_user
      queue_item.destroy
    else
      flash[:danger] = "This video is not in your queue"
    end
    redirect_to queue_items_path
  end

  private

  def queue_item_last_position
    current_user.queue_items.count + 1
  end
end
