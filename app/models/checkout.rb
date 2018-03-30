class Checkout
  include Mongoid::Document
  # field :paid, type: Boolean, default: false
  field :delivery_method, type: Integer
  field :payment_method, type: Integer
  field :delivery_address, type: CheckoutAddress
  field :billing_address, type: CheckoutAddress
  has_many :cart_items, dependent: :destroy
  
  belongs_to :user

  def move_items_from_cart
    # byebug
    # TODO: make sure why method is missing - is cart deleted before or unavailable in checkout???
    c_items = []
    self.user.cart.cart_items.each do |c_item|
      c_items.push(c_item)
      # self.cart_items.push(c_item)
    end
    self.update(cart_items: c_items)
  end
end
