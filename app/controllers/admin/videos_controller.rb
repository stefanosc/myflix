class Admin::VideosController < AdminsController
  def new
    @video = Video.new
  end

  def create
    category = Category.find(video_params[:category])
    @video = Video.new(video_params.merge(category: category))
    if @video.save
      flash[:success] = "Successfully created video"
      redirect_to new_admin_video_path
    else
      render :new
    end
  end

  private

  def video_params
    params.require(:video).permit(:title, :description, :category, :large_cover, :small_cover, :remote_video_url)
  end
end
