class CheckoutsController < ApplicationController
  before_action :set_checkout, only: %i[edit update]
  
  def edit
  end
  
  def update
  end

  def show
  end
  
  private

  def set_checkout
    p Checkout.count
    p Checkout.last.id
    @checkout = Checkout.find(params[:id])
  end

  def event_params
    params.require(:checkout).permit(:name, :user_id, :image,
                                  address_attributes: %i[city street
                                                         house_number zip_code])
  end
end
