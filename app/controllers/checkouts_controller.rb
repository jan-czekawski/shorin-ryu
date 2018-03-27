class CheckoutsController < ApplicationController
  before_action :set_checkout, only: %i[edit update]
  
  def new
    @checkout = Checkout.new
    @checkout.cart = current_user.cart
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
  
  private

  def set_checkout
    # p Cart.last.id
    # p Cart.count
    # p params[:id]
    # p Checkout.last.id
    # p Checkout.count
    # FIXME: make sure correct id is passed in params
    # @checkout = Checkout.find(params[:id])
    @checkout = current_user.cart.checkout
  end

  def event_params
    params.require(:checkout).permit(:name, :user_id, :image,
                                  address_attributes: %i[city street
                                                         house_number zip_code])
  end
end
