class Comment
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :user
  belongs_to :commentable, polymorphic: true

  field "content", type: String
  validates :content, presence: true
end
