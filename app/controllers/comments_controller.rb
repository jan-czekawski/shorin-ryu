class CommentsController < ApplicationController
  # before_action :require_user
  before_action :set_comment, only: [:destroy] #,:create, :update, ]
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
      redirect_to @commentable
    else
      flash[:alert] = "There was an error!" + @comment.errors.full_messages.to_s
      # TODO: change it
      redirect_to @commentable
    end
  end
  
  def update
  end
  
  def destroy
  end
  
  def find_commentable
    params.each do |name, value| 
      if name =~ (/(.+)_id/)
        return $1.classify.constantize.find(value)
      end
    end
  end
  
  def set_comment
    @comment = params[:id]
  end
  
  def comment_params
    params.require(:comment).permit(:content)
  end
  
end



