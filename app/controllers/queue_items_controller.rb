class QueueItemsController < ApplicationController

  before_action :require_user

  def index
    @queue_items = user_queue(current_user)
  end

  def create
    
  end

  def update
    
  end

  def destroy

  end

  private

  def user_queue(user)
    user.queue_items.includes(video: [:category, :reviews]).where('reviews.user_id' => user.id)
  end


end
