class CartItemsController < ApplicationController
  before_action :set_cart, only: [:create]

  def create
    persisted_cart = Cart.find(params[:cart_id])
    @cart_item = @cart.cart_items.build(cart_items_params)
    # p persisted_cart.cart_items.include?(@cart_item)

    already_in_cart = persisted_cart.cart_items.any? do |c_item|
                        c_item.item.id == @cart_item.item.id
                      end
    # @current_item = @cart.current_item(cart_items_params[:item_id])                 
    if already_in_cart
      # current_item.quantity += cart_items_params[:quantity].to_i
      persisted_cart.cart_items.each do |c_item_to|
        if c_item_to.item.id == @cart_item.item.id
          c_item_to.quantity += @cart_item.quantity 
          CartItem.find(c_item_to.id).update(quantity: c_item_to.quantity)
        end
      end
      flash[:success] = "Item's quantity in the cart has been updated."
      redirect_to cart_path(@cart)
    else
      if @cart_item.save
        flash[:success] = "Item has been added to your cart."
        redirect_to cart_path(@cart)
      else
        flash[:alert] = @cart_item.display_errors
        redirect_back fallback_location: items_path
      end      
    end
  end

  def destroy
    CartItem.find(params[:id]).delete
    flash[:success] = "Item has been deleted from your cart."
    redirect_back fallback_location: items_path
  end
  
  private

  def cart_items_params
    params.require(:cart_item).permit(:quantity, :item_id)
  end
end
