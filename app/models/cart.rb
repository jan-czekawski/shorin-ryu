class Cart
  include Mongoid::Document
  include Price

  belongs_to :user
  has_many :cart_items, dependent: :destroy
end
