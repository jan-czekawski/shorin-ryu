require 'rails_helper'

RSpec.describe CartItem, type: :model do
  describe CartItem, ".new" do
    it "creates valid cart_item if all info is provided" do
      cart_item = build(:cart_item)
      expect(cart_item).to be_valid
    end
    
    it "requires item_id" do
      cart_item = build(:cart_item, item_id: nil)
      expect(cart_item).not_to be_valid
    end
    
    it "requires cart_id" do
      cart_item = build(:cart_item, cart_id: nil)
      expect(cart_item).not_to be_valid
    end
    
    it "requires quantity" do
      cart_item = build(:cart_item, quantity: nil)
      expect(cart_item).not_to be_valid
    end

    it "requires quantity to be integer" do
      cart_item = build(:cart_item, quantity: 1.2)
      expect(cart_item).not_to be_valid
    end
    
    it "requires quantity to be bigger or equal to 1" do
      cart_item = build(:cart_item, quantity: 0)
      expect(cart_item).not_to be_valid
    end
  end
end