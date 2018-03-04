require "rails_helper"

RSpec.describe CartItemsController, type: :controller do
  before(:all) do
    @cart = create(:cart)
    @item = create(:item)
  end
  
  describe "#create" do
    context "when user logged in" do
      before(:each) { sign_in @cart.user }
      
      describe "with valid item information" do
        it "increases cart item count by 1" do
          expect do
            post :create, params: { cart_id: @cart.id,
                                    cart_item: { quantity: 3,
                                                 item_id: @item.id } }
          end.to change(CartItem, :count).by(1)
        end
        
        it "redirects to cart after creation" do
          post :create, params: { cart_id: @cart.id,
                                  cart_item: { quantity: 20,
                                               item_id: @item.id } }
          expect(response).to redirect_to @cart
        end
      end
      
      describe "with invalid item information" do
        it "doesn't change cart item count" do
          last_item = @cart.cart_items.last
          expect do
            post :create, params: { cart_id: @cart.id,
                                    cart_item: { quantity: 10,
                                                 item_id: @item.id } }
            last_item.reload
          end.to change(last_item, :quantity).by(10)
        end
      end
    end
  end
end