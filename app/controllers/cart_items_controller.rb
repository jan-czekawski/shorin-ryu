class CartItemsController < ApplicationController
  def create
    @cart = Cart.find(params[:cart_id])
    @cart_item = @cart.cart_items.build(cart_items_params)
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

  private

  def cart_items_params
    params.require(:cart_item).permit(:quantity, :item_id)
  end
end
