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
  
  def image
    content = @user.image.read
    if stale?(etag: content, last_modified: @user.updated_at.utc, public: true)
      send_data content, type: @user.image.file.content_type, disposition: "inline"
      expires_in 0, public: true
    end
  end
  
  private

  def set_user
    @user = User.find(params[:id])
  end
  
end
