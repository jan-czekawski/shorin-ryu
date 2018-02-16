class CartItem
  include Mongoid::Document

  belongs_to :cart
  belongs_to :item
end
