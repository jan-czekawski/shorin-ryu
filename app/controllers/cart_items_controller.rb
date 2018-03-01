class CartItemsController < ApplicationController
  def create
    p params
    @cart = Cart.find(params[:cart_id])
    p cart_items_params
    @cart_item = @cart.cart_items.build(cart_items_params)
    p @cart.cart_items
    p @cart.errors.full_messages
    if @cart.save
      flash[:success] = "Item has been added to your cart."
    else
      flash[:danger] = "There's been an error."
    end
    redirect_to cart_path(@cart)
  end
  
  private
  
  def cart_items_params
    params.permit(:quantity, :item_id, :cart_id)
  end
end
