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
        context "when item not in the cart" do
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
        
        context "when item already in the cart" do
          it "increases items quantity in the cart" do
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
      
      describe "with invalid item information" do
        it "doesn't change cart items count" do
          expect do
            post :create, params: { cart_id: @cart.id,
                                    cart_item: { quantity: 10,
                                                 item_id: nil } }
          end.not_to change(CartItem, :count)
        end
      end
    end
  end
  
  describe "#update" do
    context "when user logged in" do
      before(:each) { sign_in @cart.user }
      
      describe "when item already in the cart" do
        it "updates items quantity" do
          last_item = @cart.cart_items.last
          expect do
            patch :update, params: {   cart_id: @cart.id,
                                            id: last_item.id,
                                     cart_item: { quantity: 5 } }
            last_item.reload
          end.to change(last_item, :quantity).by(-5)
        end
      end
    end
  end
end