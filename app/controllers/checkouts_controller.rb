class CheckoutsController < ApplicationController
  before_action :require_user, only: %i[new edit show destroy]
  before_action :set_checkout, only: %i[edit update show destroy]

  def new
    @checkout = Checkout.new
    @checkout.user_id = current_user.id
    @checkout.move_items_from_cart
    # TODO: needs to fix delete items from checkout links => from cart to checkout
  end

  def create; end

  def edit; end

  def update
    # TODO: remove cart items from cart after checkout payment is successf
    # CART_ITEMS should be removed when "go to checkout" button is clicked,
    # not when payment is successful
  end

  def show; end

  def destroy
    @checkout.cart_items.delete_all
  end

  private

  def set_checkout
    # p Cart.last.id
    # p Cart.count
    # p params[:id]
    # p Checkout.last.id
    # p Checkout.count
    # FIXME: make sure correct id is passed in params
    @checkout = Checkout.find(params[:id])
    # @checkout = current_user.cart.checkout
  end

  def event_params
    params.require(:checkout).permit(:name, :user_id, :image,
                                     address_attributes: %i[city
                                                            street
                                                            house_number
                                                            zip_code])
  end
end
