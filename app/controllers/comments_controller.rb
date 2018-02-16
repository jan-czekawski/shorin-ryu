class CommentsController < ApplicationController
  # before_action :require_user
  before_action :set_comment, only: [:destroy] #,:create, :update, ]
  before_action :require_user, only: [:create]
  before_action :set_event, only: [:create]
  
  def index
    @comments = Comment.all
  end
  
  def create
    @comment = @event.comments.build(comment_params)
    @comment.user_id = current_user.id
    if @comment.save
      flash[:info] = "New comment has been added!"
      redirect_to events_path
    else
      flash[:alert] = "There was an error!" + @comment.errors.full_messages.to_s
      redirect_to events_path
    end
  end
  
  def update
  end
  
  def destroy
  end
  
  def set_comment
    @comment = params[:id]
  end
  
  def comment_params
    params.require(:comment).permit(:content)
    # params.require(:comment).permit(:content).permit(:user_id, :event_id)
  end
  
  def set_event
    @event = Event.find(params[:event_id])
  end
end



