class Checkout
  include Mongoid::Document
  # field :paid, type: Boolean, default: false
  field :delivery_method, type: Integer
  field :payment_method, type: Integer
  field :delivery_address, type: CheckoutAddress
  field :billing_address, type: CheckoutAddress
  belongs_to :cart

  def move_items_from_cart
    # move cart_items to @checkout
  end
end
