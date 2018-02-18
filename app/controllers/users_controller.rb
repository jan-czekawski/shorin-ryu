class UsersController < ApplicationController
  before_action :set_user, only: [:show, :destroy]
  before_action :require_user, only: [:index, :destroy]
  before_action :require_admin, only: [:destroy]
  rescue_from Mongoid::Errors::DocumentNotFound, with: :wrong_user
  
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
  
  def wrong_user
    logger.error "Can't access invalid user #{params[:id]}"
    flash[:danger] = "Invalid user."
    redirect_to users_path
  end
  
end
