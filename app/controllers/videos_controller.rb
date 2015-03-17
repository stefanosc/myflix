class VideosController < UserAuthenticationController

  before_action :find_video, only: [:show]


  def index
    @categories = Category.all
  end

  def show
    @reviews = @video.recent_reviews
  end

  def search
    @q = params[:q]
    @videos = Video.search_by_title(@q).first(6)
  end

  private

  def find_video
    @video = Video.find_by_slug(params[:id]).decorate
  end

end
