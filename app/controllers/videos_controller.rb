class VideosController < ApplicationController

  before_action :find_video, only: [:show]

  def index
    @categories = Category.all    
  end  

  def show
    
  end
  
  private

  def find_video
    @video = Video.find_by_slug(params[:id])
  end

end