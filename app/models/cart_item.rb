class CartItem
  include Mongoid::Document
  include HandleErrors
  
  belongs_to :item
  belongs_to :cart
  field :quantity, type: Integer
  
  validates :quantity, numericality: { only_integer: true,
                                       greater_than_or_equal_to: 1 }
  
  def self.add_to_cart(c_item, page_params, cart)
    if c_item.persisted?
      c_item[:quantity] += page_params[:quantity].to_i
      c_item
    else
      c_item = cart.cart_items.build(page_params)
    end
  end
end
