require 'rails_helper'

RSpec.describe Cart, type: :model do
  describe Cart, "#sum_price" do
    it "returns sum of all items" do
      cart = build(:cart)
      item = build(:item, price: 50.0)
      cart_item = build(:cart_item, cart: cart, quantity: 3, item: item)
      expect(cart).to have_total_price_equal_to 150
    end
  end
end
