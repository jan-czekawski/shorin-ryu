class Comment
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :user
  belongs_to :commentable, polymorphic: true

  field "content", type: String
  validates :content, :commentable_type, presence: true

  def display_errors
    error = "There is an error. "
    errors.full_messages.each { |msg| error += msg + "." }
    error
  end
end
