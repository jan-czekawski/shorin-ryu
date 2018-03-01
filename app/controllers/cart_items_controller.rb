class CartItemsController < ApplicationController
  def create
    @cart = Cart.find(params[:cart_id])
    @cart_item = @cart.cart_items.build(cart_items_params)
    if @cart_item.save
      flash[:success] = "Item has been added to your cart."
    else
      flash[:danger] = "There's been an error."
    end
    redirect_to cart_path(@cart)
  end
  
  private
  
  def cart_items_params
    params.require(:cart_item).permit(:quantity, :item_id)
  end
end
