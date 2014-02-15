class VideosController < ApplicationController

  before_action :find_video, only: [:show]
  before_action :require_user


  def index
    @categories = Category.all    
  end  

  def show
    @reviews = @video.reviews
  end

  def search
    @q = params[:q]
    @videos = []
    Video.search_by_title(@q).each_slice(6) { |v| @videos << v }
  end
  
  private

  def find_video
    @video = Video.find_by_slug(params[:id])
  end

end