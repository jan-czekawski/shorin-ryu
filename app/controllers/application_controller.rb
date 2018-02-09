class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  
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

end
