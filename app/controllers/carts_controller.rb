class CartsController < ApplicationController
  before_action :set_cart, only: [:show]

  def show; end
    
  # TODO: add rendering content of the cart in the sidebar => <%= j render @cart* %>

  private

  def set_cart
    @cart = Cart.find(params[:id])
  end
end
