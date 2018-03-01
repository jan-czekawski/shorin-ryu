module UserRequirements
  def require_user
    return if user_signed_in?
    flash[:alert] = "You must be logged in to do that!"
    redirect_to new_user_session_url
  end

  def require_same_user
    return if current_user.events.include?(@event) || current_user.admin?
    flash[:alert] = "You can only delete events you've created."
    redirect_to events_path
  end
  
  def require_admin
    return if current_user.admin?
    flash[:alert] = "You must be an admin to do that!"
    redirect_to root_path
  end

  def require_owner_or_admin
    same_user = Comment.find(params[:id]).user == current_user
    return if same_user || current_user.admin?
    flash[:alert] = "You must be an owner or an admin to do that!"
    redirect_to root_path
  end
end