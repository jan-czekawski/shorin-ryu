class ItemsController < ApplicationController
  before_action :set_item, only: %i[show edit update destroy]
  before_action :require_user, only: %i[new create edit update destroy]
  before_action :require_admin, only: %i[new create edit update destroy]

  def index
    @items = Item.all
  end

  def show; end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      flash[:info] = "New item has been created."
      redirect_to items_path
    else
      render "new"
    end
  end

  def edit; end

  def update
    if @item.update(item_params)
      flash[:info] = "Item has been updated."
      redirect_to item_path(@item)
    else
      render "edit"
    end
  end

  def destroy
    @item.delete
    flash[:danger] = "Item has been deleted"
    redirect_to items_path
  end

  private
  
  def item_params
    params.require(:item).permit(:name, :image, :store_item_id, :price,
                                 :description, :size)
  end

  def set_item
    @item = Item.find(params[:id])
  end
end
