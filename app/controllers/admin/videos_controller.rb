class Admin::VideosController < AdminsController
  def new
    @video = Video.new
  end

  def create
        # TODO
    @video = Video.new(video_params)
    if @video.save
      flash[:success] = "Successfully created video"
      redirect_to home_path
    else
      render :new
    end
  end

  private

  def video_params
    params.require(:video).permit(:title, :category_id, :description, :large_cover_url, :small_cover_url)
  end
end
