class CartsController < ApplicationController
  before_action :set_cart, only: [:show]

  def show; end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_cart
    @cart = Cart.find(params[:id])
  end
end
