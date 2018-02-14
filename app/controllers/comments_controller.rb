class CommentsController < ApplicationController
  # before_action :require_user
  before_action :set_comment, only: [:create, :update, :destroy]
  
  def index
    @comments = Comment.all
  end
  
  def create
  end
  
  def update
  end
  
  def destroy
  end
  
  def set_comment
    @comment = params[:id]
  end
end
