module Price
  def sum_price
    sum = 0
    # TODO: fix @cart in items/show and items/index - to not include |
    # not persisted cart_items in @cart
    cart_items.select(&:persisted?).each do |c_item|
      sum += c_item.quantity * c_item.item.price
    end
    sum
  end
end
