class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_class, except: [:home]
  before_action :set_flash, only: [:home]

  def home; end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[login image])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[login image])
  end

  private

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
  
  def require_owner_or_admin
    same_user = Comment.find(params[:id]).user == current_user
    return if same_user || current_user.admin?
    flash[:alert] = "You must be an owner or an admin to do that!"
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
