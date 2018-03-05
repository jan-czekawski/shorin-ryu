class CartItemsController < ApplicationController
  before_action :set_cart, only: [:create]

  def create
    item = @cart.in_cart_already(cart_items_params[:item_id])
    item = CartItem.add_to_cart(item, cart_items_params, @cart)
    
    if item.save
      flash[:success] = "Item has been added to your cart."
      redirect_to cart_path(@cart)
    else
      flash[:alert] = item.display_errors
      redirect_back fallback_location: items_path
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
