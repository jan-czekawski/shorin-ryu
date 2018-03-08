class Item
  include Mongoid::Document
  include Mongoid::Timestamps
  attr_accessor :image, :image_cache
  mount_uploader :image, ImageUploader

  field :name, type: String
  field :description, type: String
  field :price, type: Float
  field :store_item_id, type: Integer
  field :image, type: String, default: ""
  field :size, type: String
  # embeds_one :size
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :cart_items, dependent: :destroy
  # embedded_in :cart

  validates :name, :description, :price, :size,
            :store_item_id, presence: true
  validates :name, :store_item_id, uniqueness: true
  validates :price, numericality: { greater_than_or_equal_to: 0.01 }
  validates :size, format: {
    with: /\A(xs|s|m|l|xl|xxl)\z/,
    message: "must be xs, s, m, l, xl or xxl."
  }
  # accepts_nested_attributes_for :size
  # validates_associated :size
end
