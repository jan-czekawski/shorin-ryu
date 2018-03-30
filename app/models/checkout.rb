class Checkout
  include Mongoid::Document
  # field :paid, type: Boolean, default: false
  field :delivery_method, type: Integer
  field :payment_method, type: Integer
  field :delivery_address, type: CheckoutAddress
  field :billing_address, type: CheckoutAddress
  belongs_to :user

  def move_items_from_cart
    
  end
end
