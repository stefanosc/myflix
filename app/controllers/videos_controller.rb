class VideosController < ApplicationController

  before_action :find_video, only: [:show]

  def index
    @videos = Video.limit(6)    
  end  

  def show
    
  end
  
  private

  def find_video
    @video = Video.find_by_slug(params[:id])
  end

end