class CommentsController < ApplicationController
  before_action :set_comment, only: [:destroy]
  before_action :require_user, only: [:create]
  # before_action :set_event, only: [:create]

  def index
    @comments = Comment.all
  end

  def create
    @commentable = find_commentable
    @comment = @commentable.comments.build(comment_params)
    @comment.user_id = current_user.id
    if @comment.save
      flash[:info] = "New comment has been added!"
      # TODO: change it
      # redirect_to @commentable
    else
      flash[:alert] = "There was an error!" + @comment.errors.full_messages.to_s
      # TODO: change it
    end
    redirect_to @commentable
  end

  def destroy
    
  end

  def find_commentable
    params.each do |name, value|
      return $1.classify.constantize.find(value) if name =~ /(.+)_id/
    end
  end

  def set_comment
    @comment = params[:id]
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
