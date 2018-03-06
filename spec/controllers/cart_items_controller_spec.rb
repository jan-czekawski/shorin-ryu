require "rails_helper"

RSpec.describe CartItemsController, type: :controller do
  describe "#create" do
    context "when user logged in" do
      describe "with valid item information" do
        context "when item not in the cart" do
          it "increases cart item count by 1 and redirects to cart" do
            item = create(:item)
            cart = create(:cart)
            sign_in cart.user

            expect do
              post :create, params: { cart_id: cart.id,
                                      cart_item: { quantity: 3,
                                                   item_id: item } }
            end.to change(CartItem, :count).by(1)
            expect(response).to redirect_to cart
          end
        end
        
        context "when item already in the cart" do
          it "increases items quantity in the cart and redirects to cart" do
            cart = create(:cart)
            cart_item = create(:cart_item, cart: cart)
            sign_in cart.user
            last_c_item = cart.cart_items.last
            expect do
              post :create, params: { cart_id: cart.id,
                                      cart_item: { quantity: 10,
                                                   item_id: last_c_item.item.id } }
              last_c_item.reload
            end.to change(last_c_item, :quantity).by(10)
            expect(response).to redirect_to cart
          end
        end
      end
      
      describe "with invalid item information" do
        it "doesn't change cart items count" do
          cart = create(:cart)
          sign_in cart.user
          expect do
            post :create, params: { cart_id: cart.id,
                                    cart_item: { quantity: 10,
                                                 item_id: nil } }
          end.not_to change(CartItem, :count)
        end
      end
    end
  end
  
  describe "#update" do
    context "when user logged in" do
      context "when item already in the cart" do
        it "updates items quantity and redirects to cart" do
          cart = create(:cart)
          c_item = create(:cart_item, cart: cart, quantity: 10)
          sign_in cart.user
          expect do
            patch :update, params: {   cart_id: cart.id,
                                            id: c_item.id,
                                     cart_item: { quantity: 5 } }
            c_item.reload
          end.to change(c_item, :quantity).by(-5)  
          expect(response).to redirect_to cart
        end
      end
      
      context "when item is not in your cart" do
        it "doesn't update item's quantity and redirects to your cart" do
          cart = create(:cart)
          item_in_2nd_cart = create(:cart_item, quantity: 10)
          sign_in cart.user
          expect do
            patch :update, params: { cart_id: cart.id,
                                     id: item_in_2nd_cart.id,
                                     cart_item: { quantity: 9 } }
            item_in_2nd_cart.reload
          end.not_to change(item_in_2nd_cart, :quantity)
          expect(response).to redirect_to cart
        end
      end
      
      describe "when accessing not your cart" do
        it "doesn't update item's quantity and redirects to your cart" do
          cart = create(:cart)
          item_in_2nd_cart = create(:cart_item, quantity: 10)
          sign_in cart.user
          expect do
            patch :update, params: { cart_id: item_in_2nd_cart.cart.id,
                                     id: item_in_2nd_cart.id,
                                     cart_item: { quantity: 9 } }
            item_in_2nd_cart.reload  
          end.not_to change(item_in_2nd_cart, :quantity)
          expect(response).to redirect_to cart
        end
      end
    end
  end
end