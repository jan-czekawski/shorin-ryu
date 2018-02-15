class CommentsController < ApplicationController
  # before_action :require_user
  before_action :set_comment, only: [:destroy] #,:create, :update, ]
  before_action :require_user, only: [:create]
  before_action :set_event, only: [:create]
  
  def index
    @comments = Comment.all
  end
  
  def create
    @event.comments.create(comment_params)
  end
  
  def update
  end
  
  def destroy
  end
  
  def set_comment
    @comment = params[:id]
  end
  
  def comment_params
    params.require(:comment).permit(:content, :commentable_type, :commentable_id, :user)
  end
end



