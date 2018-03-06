require 'rails_helper'

RSpec.describe Cart, type: :model do
  describe Cart, "#sum_price" do
    it "returns sum of all items" do
      item = build(:item, price: 50.0)
      cart_item = build_stubbed(:cart_item, quantity: 3, item: item)        
      expect(cart_item.cart).to have_total_price_equal_to 150
    end
  end
end
