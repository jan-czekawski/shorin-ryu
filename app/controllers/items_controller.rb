class ItemsController < ApplicationController
  def index
    @items = Item.all
  end

  def show
  end

  def new
    @item = Item.new
    @item.build_size
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

  def edit
  end

  def update
  end

  def delete
  end
  
  def item_params
    params.require(:item).permit(:name, :image, :store_item_id, :price,
                                 :description, size_attributes: [:xs, :sml, :med,
                                                                 :lrg, :x_lrg, :xx_lrg])
  end
end
