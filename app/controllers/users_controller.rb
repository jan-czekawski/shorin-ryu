class UsersController < ApplicationController
  before_action :set_user, only: [:show, :destroy]
  before_action :require_user, only: [:index, :destroy]
  before_action :require_admin, only: [:destroy]
  
  def index
    @users = User.all
  end
  
  def show; end
  
  def destroy
    @user.destroy
    flash[:alert] = "User was deleted!"
    redirect_to users_path
  end
  
  private

  def set_user
    @user = User.find(params[:id])
  end
  
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
