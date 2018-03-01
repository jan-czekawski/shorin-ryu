module Price
  def sum_price
    cart_items.map { |c_item| c_item.quantity * c_item.item.price }
  end
end