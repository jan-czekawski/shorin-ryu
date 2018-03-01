class Cart
  include Mongoid::Document
  belongs_to :user
  has_many :cart_items
end
