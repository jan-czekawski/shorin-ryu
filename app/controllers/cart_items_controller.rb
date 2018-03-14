class CartItemsController < ApplicationController
  before_action :require_user, only: %i[create update destroy]
  before_action :set_cart_for_user, only: %i[create]
  before_action :set_cart_and_cart_item, only: %i[update destroy]
  before_action :require_same_cart, only: %i[update destroy]
  before_action :require_item_in_cart, only: %i[update destroy]

  def create
    cart_item = CartItem.check_if_already_in_cart(@cart, cart_items_params[:item_id])
    cart_item = CartItem.add_to_cart(@cart, cart_item, cart_items_params)
    
    respond_to do |format|
      if cart_item.save
        format.html do
          flash[:success] = "Item has been added to your cart."
          redirect_to cart_path(@cart)
        end
        format.js do
          flash.now[:success] = "Item has been added to your cart."
        end
      else
        format.html do
          flash[:alert] = cart_item.display_errors
          redirect_back fallback_location: items_path
        end
      end
    end
  end
  
  def update
    respond_to do |format|
      if @cart_item.update(cart_items_params)
        format.html do
          flash[:success] = "Item's quantity has been updated."
          redirect_to cart_path(current_user.cart)
        end
        format.js do
          # flash.now[:success] = "Item has been deleted from your cart."
        end
      else
        format.html do
          flash[:alert] = @cart_item.display_errors
          redirect_to root_url
        end
      end
    end
    
  end

  def destroy
    respond_to do |format|
      @cart_item.delete
      format.js do
        flash.now[:success] = "Item has been deleted from your cart."
      end
      format.html do
        flash[:success] = "Item has been deleted from your cart."
        redirect_back fallback_location: items_path
      end
    end
  end
  
  private

  include CartRequirements
end
