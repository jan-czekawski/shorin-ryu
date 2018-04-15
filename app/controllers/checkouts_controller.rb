class CheckoutsController < ApplicationController
  before_action :require_user, only: %i[new edit show]
  before_action :set_checkout, only: %i[edit update show destroy]

  def new
    @checkout = Checkout.new
    @checkout.user_id = current_user.id
    @checkout.move_items_from_cart
  end
  
  def create
  end
  
  def edit
  end
  
  def update
    # TODO: remove cart items from cart after checkout payment is successed
  end

  def show
  end
  
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
                                  address_attributes: %i[city street
                                                         house_number zip_code])
  end
end
