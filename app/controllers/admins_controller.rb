class AdminsController < UserAuthenticationController

  before_action :require_admin

  def require_admin
    unless current_user.admin?
      flash[:danger] = "You are not authorized to access this page"
      redirect_to root_path
    end
  end
end
