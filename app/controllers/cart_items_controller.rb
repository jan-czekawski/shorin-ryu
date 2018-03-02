class CartItemsController < ApplicationController
  def create
    @cart = Cart.find(params[:cart_id])
    @cart_item = @cart.cart_items.build(cart_items_params)
    # item_in_cart = Cart.find(params[:cart_id]).cart_items.any? do |c_item|
    #                 c_item.item.id == @cart_item.item.id
    #               end
    item_in_cart = false
    if item_in_cart
      
    else
      if @cart_item.save
        flash[:success] = "Item has been added to your cart."
        redirect_to cart_path(@cart)
      else
        flash[:alert] = "There's been an error. "
        @cart_item.errors.full_messages.each do |msg|
          flash[:alert] += msg + ". "
        end
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
