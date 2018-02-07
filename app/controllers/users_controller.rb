class UsersController < ApplicationController
  before_action :logged_in?, only: [:index]
  before_action :set_user, only: [:show, :destroy]
  
  def index
    @users = User.all
  end
  
  def show
  end
  
  def destroy
    @user.destroy
    flash[:notice] = "User was deleted!"
    redirect_to root_path
  end
  
  private
  
  def logged_in?
    redirect_to root_path unless user_signed_in?
  end
  
  def set_user
    @user = User.find(params[:id])
  end
end
