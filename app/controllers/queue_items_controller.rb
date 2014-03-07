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

  def update_queue
    queue_items_params.each do |queue_item_input|
      QueueItem.find(queue_item_input[:id]).update(position: queue_item_input[:position])
      current_user.queue_items.each_with_index { |queue_item, i| queue_item.update(position: i+1 )}
    end

    redirect_to queue_items_path
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

  def queue_items_params
    params.permit(queue_items:[:id, :position])[:queue_items]
  end

  def queue_item_last_position
    current_user.queue_items.count + 1
  end
end
