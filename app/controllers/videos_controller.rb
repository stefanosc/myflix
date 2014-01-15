class VideosController < ApplicationController

  def index
    @videos = Video.limit(6)    
  end  
  
end