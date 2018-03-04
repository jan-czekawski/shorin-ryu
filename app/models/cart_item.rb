class CartItem
  include Mongoid::Document
  include HandleErrors
  
  belongs_to :item
  belongs_to :cart
  field :quantity, type: Integer
  
  validates :quantity, numericality: { only_integer: true,
                                       greater_than_or_equal_to: 1 }
end
