class UsersController < ApplicationController
  before_action :set_user, only: %i[show destroy]
  before_action :require_user, only: %i[index show destroy]
  before_action :require_admin, only: [:destroy]

  include HandleErrors
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
end
