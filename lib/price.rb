module Price
  def sum_price
    sum = 0
    cart_items.each do |c_item|
      sum += c_item.quantity * c_item.item.price
    end
    sum
  end
end
