class Comment
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :user
  belongs_to :commentable, polymorphic: true

  field "content", type: String
  validates :content, :commentable_type, presence: true

  
  def get_commentable_type
    type = commentable_type.constantize
    type.find(commentable_id)
  end
end
