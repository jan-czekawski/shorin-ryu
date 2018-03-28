class Event
  include Mongoid::Document
  include Mongoid::Timestamps

  attr_accessor :image, :image_cache
  mount_uploader :image, ImageUploader

  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy
  has_one :address
  # TODO: go back to relation if checkout address won't work
  # FIXME: in events index view there's temporary fix to display address
  
  # field :address, type: CheckoutAddress
  field :name,  type: String
  field :image, type: String, default: ""
  
  # embeds_one :address
  accepts_nested_attributes_for :address

  validates :name, :address, presence: true
  validates_associated :address
end
