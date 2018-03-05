class CartItemsController < ApplicationController
  before_action :set_cart, only: [:create]
  before_action :set_cart_item, only: %i[update, destroy]

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
  
  def update
    if @cart_item.update(cart_items_params)
      # flash[:success] = "Item's quantity has been updated."
      # redirect_to cart_path()
    else
      
    end
  end

  def destroy
    @cart_item.delete
    flash[:success] = "Item has been deleted from your cart."
    redirect_back fallback_location: items_path
  end
  
  private

  def set_cart_item
    @cart_item = CartItem.find(params[:id])
  end

  def cart_items_params
    params.require(:cart_item).permit(:quantity, :item_id)
  end
end
