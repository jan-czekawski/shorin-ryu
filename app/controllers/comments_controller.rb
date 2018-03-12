class CommentsController < ApplicationController
  before_action :set_comment, only: [:destroy]
  before_action :require_valid_commentable_id, only: [:destroy]
  before_action :require_user, only: %i[create destroy]
  before_action :require_owner_or_admin, only: [:destroy]

  include Commentable

  def create
    # TODO: add ajax to comments view, carts view
    @commentable = find_commentable
    @comment = @commentable.comments.build(comment_params)
    @comment.user_id = current_user.id
    
    if @comment.save
      flash[:success] = "New comment has been added!"
    else
      flash[:alert] = @comment.display_errors
    end
    redirect_to @commentable
  end

  def destroy
    @comment.delete
    flash[:alert] = "Comment has been deleted."
    redirect_to @commentable
  end

  private

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
