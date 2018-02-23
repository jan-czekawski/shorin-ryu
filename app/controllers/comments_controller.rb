class CommentsController < ApplicationController
  before_action :set_comment, only: [:destroy]
  before_action :require_user, only: %i[create destroy]
  before_action :require_owner_or_admin, only: [:destroy]

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
    @comment.delete
    flash[:danger] = "Comment has been deleted."
    redirect_to find_commentable
  end

  def find_commentable
    params.each do |name, value|
      return $1.classify.constantize.find(value) if name =~ /(.+)_id/
    end
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
