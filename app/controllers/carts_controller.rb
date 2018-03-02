class CartsController < ApplicationController
  # before_action :set_cart, only: %i[show edit update destroy]

  # GET /carts
  # GET /carts.json
  def index
    @carts = Cart.all
  end

  # GET /carts/1
  # GET /carts/1.json
  def show; end

  # # GET /carts/new
  # def new
  #   @cart = Cart.new
  # end

  # # GET /carts/1/edit
  # def edit
  # end

  # POST /carts
  # POST /carts.json
  def create
    @cart.cart_items.build(cart_params)
    @cart.user_id = current_user.id
    if @cart.save
      flash[:success] = "Cart has been created."
      redirect_to cart_path(@cart)
    else
      render :new
    end
  end

  # PATCH/PUT /carts/1
  # PATCH/PUT /carts/1.json
  def update
    if @cart.update(cart_params)
      redirect_to @cart
      flash[:notice] = "Cart was successfully updated."
    else
      render :edit
    end
  end

  # DELETE /carts/1
  # DELETE /carts/1.json
  def destroy
    @cart.delete
    flash[:notice] = "Cart was successfully destroyed."
    redirect_to carts_url
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_cart
    @cart = Cart.find(params[:id])
  end

  # Never trust parameters from the scary internet,
  # only allow the white list through.
  def cart_params
    params.require(:cart).permit(:quantity)
  end
end
