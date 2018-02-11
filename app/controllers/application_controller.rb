class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_class, except: [:home]
  before_action :set_flash, only: [:home]
  
  def home; end

  def require_user
    return if user_signed_in?
    flash[:alert] = "You must be logged in to do that!"
    redirect_to root_path
  end
  
  def require_admin
    return if current_user.admin?
    flash[:alert] = "You must be an admin to do that!"
    redirect_to root_path
  end
  
  def set_class
    @body_class = "container-fluid"
  end
  
  def set_flash
    @flash_row = "row justify-content-center"
    @flash_col = "col-10 absolute"
  end

end
