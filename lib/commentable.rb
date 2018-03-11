module Commentable
  def find_commentable
    params.each do |name, value|
      # return $1.classify.constantize.find(value) if name =~ /(.+)_id/
      return Object.const_get($1.capitalize).find(value) if name =~ /(.+)_id/
    end
  end
  
  def require_valid_commentable_id
    @commentable = find_commentable
    return if @comment.commentable_id == @commentable.id    
    flash[:alert] = "#{@commentable.class}_id is not correct for that comment."
    redirect_to root_url
  end
end
