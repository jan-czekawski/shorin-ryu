module HandleErrors
  def wrong_user
    logger.error "Can't access invalid user #{params[:id]}"
    flash[:danger] = "Invalid user."
    redirect_to users_path
  end
end