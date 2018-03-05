class CartItem
  include Mongoid::Document
  include HandleErrors
  
  belongs_to :item
  belongs_to :cart
  field :quantity, type: Integer
  
  validates :quantity, numericality: { only_integer: true,
                                       greater_than_or_equal_to: 1 }
  
  # def add_to_cart(page_params)
  #   if self.quantity
  #     self.quantity += page_params[:quantity].to_i
  #     flash[:success] = "Item's quantity in the cart has been updated."
  #   else
  #     flash[:success] = "Item has been added to your cart."
  #     return item = cart.cart_items.build(page_params)
  #   end
  #   self
  # end
  
end
