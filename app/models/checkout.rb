class Checkout
  include Price
  include Mongoid::Document
  # field :paid, type: Boolean, default: false
  field :delivery_method, type: Integer
  field :payment_method, type: Integer
  field :delivery_address, type: CheckoutAddress
  field :billing_address, type: CheckoutAddress
  has_many :cart_items, dependent: :destroy

  belongs_to :user

  def move_items_from_cart
    # TODO: make sure why method is missing - is cart deleted
    # before or unavailable in checkout???
    # PROBABLY FIXED!!! -> CONFIRM THAT!!!
    # self.user.cart.cart_items.each do |c_item|
    user.cart.cart_items.each do |c_item|
      # self.cart_items.build(item_id: c_item.item_id,
      cart_items.build(item_id: c_item.item_id,
                       cart_id: c_item.cart_id,
                       checkout_id: c_item.checkout_id,
                       quantity: c_item.quantity)
                .save
    end
    # self.user.cart.cart_items.delete_all
    user.cart.cart_items.delete_all
  end
end
