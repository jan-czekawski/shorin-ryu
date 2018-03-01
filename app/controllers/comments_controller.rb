class CommentsController < ApplicationController
  before_action :set_comment, only: [:destroy]
  before_action :require_user, only: %i[create destroy]
  before_action :require_owner_or_admin, only: [:destroy]

  include Commentable

  def create
    @commentable = find_commentable
    path = @commentable.is_a?(Event) ? event_path(@commentable) : item_path(@commentable)
    @comment = @commentable.comments.build(comment_params)
    @comment.user_id = current_user.id
    
    if @comment.save
      flash[:success] = "New comment has been added!"
    else
      flash[:alert] = "There is an error. "
      @comment.errors.full_messages.each do |message|
        flash[:alert] += message + "."
      end
    end
    redirect_to @commentable
  end

  def destroy
    @comment.delete
    flash[:danger] = "Comment has been deleted."
    redirect_to find_commentable
  end

  private

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
