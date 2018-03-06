class CartItemsController < ApplicationController
  before_action :require_user, only: %i[create update destroy]
  before_action :set_cart_for_user, only: %i[create]
  before_action :set_cart_and_cart_item, only: %i[update destroy]
  before_action :require_same_cart, only: %i[update destroy]
  before_action :require_item_in_cart, only: %i[update destroy]

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
      flash[:success] = "Item's quantity has been updated."
      redirect_to cart_path(current_user.cart)
    else
      flash[:alert] = @cart_item.display_errors
      redirect_to root_url
    end
    
  end

  def destroy
    @cart_item.delete
    flash[:success] = "Item has been deleted from your cart."
    redirect_back fallback_location: items_path
  end
  
  private

  def set_cart_and_cart_item
    @cart_params = Cart.find(params[:cart_id])
    @cart_item = CartItem.find(params[:id])
  end

  def cart_items_params
    params.require(:cart_item).permit(:quantity, :item_id)
  end
  
  def require_same_cart
    return if current_user.cart == @cart_params
    flash[:alert] = "You can only access your own cart."
    redirect_to current_user.cart
  end
  
  def require_item_in_cart
    return if current_user.cart.cart_items.include?(@cart_item)
    flash[:alert] = "Item wasn't in your cart."
    redirect_to current_user.cart
  end
end
