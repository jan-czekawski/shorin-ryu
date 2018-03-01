module Commentable
  def find_commentable
    params.each do |name, value|
      # return $1.classify.constantize.find(value) if name =~ /(.+)_id/
      return Object.const_get($1.capitalize).find(value) if name =~ /(.+)_id/
    end
  end
end
