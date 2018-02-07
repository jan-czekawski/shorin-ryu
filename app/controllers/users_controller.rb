class UsersController < ApplicationController
  before_action :logged_in?, only: [:index]
  
  def index
    @users = User.all
  end
  
  private
  
  def logged_in?
    redirect_to root_path unless user_signed_in?
  end
end
