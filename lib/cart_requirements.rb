module CartRequirements
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