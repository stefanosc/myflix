class RenameVideoToVideoUrlInVideos < ActiveRecord::Migration
  def change
    rename_column :videos, :video, :video_url
  end
end
