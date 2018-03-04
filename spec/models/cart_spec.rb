require 'rails_helper'

RSpec.describe Cart, type: :model do
  describe Cart, ".new" do
    it "returns sum of all items" do
      cart = build(:cart)
      item = build(:item, price: 50)
      cart_item = build(:cart_item, cart: cart, quantity: 3, item: item)
      expect(cart.sum_price).to eq 150
      # p cart.sum_price
    end
  end
end