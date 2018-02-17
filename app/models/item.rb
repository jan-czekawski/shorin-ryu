class Item
  include Mongoid::Document
  attr_accessor :image, :image_cache 
  mount_uploader :image, ImageUploader
  
  field :name, type: String
  field :description, type: String
  field :price, type: Float
  field :store_item_id, type: Integer
  field :image, type: String
  field :size, type: String
  # embeds_one :size
  has_many :comments, as: :commentable, dependent: :destroy
  # embedded_in :cart
  
  accepts_nested_attributes_for :size
  validates_associated :size
end
