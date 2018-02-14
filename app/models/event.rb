class Event
  include Mongoid::Document
  include Mongoid::Timestamps

  attr_accessor :image, :image_cache 
  mount_uploader :image, ImageUploader
  
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy
  
  field :name,  type: String
  field :image, type: String, default: ""
  # field :address, type: Hash
  embeds_one :address
  accepts_nested_attributes_for :address
  
  validates :name, presence: true
  # validates :address, presence: true
  validates_associated :address
end
