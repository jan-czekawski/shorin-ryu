class Checkout
  include Mongoid::Document
  field :delivery_method, type: Integer
  field :payment_method, type: Integer
  field :delivery_address, type: CheckoutAddress
  field :billing_address, type: CheckoutAddress
  belongs_to :cart
end
