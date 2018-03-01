class CartItem
  include Mongoid::Document

  belongs_to :item
  belongs_to :cart
  field :quantity, type: Integer
end
