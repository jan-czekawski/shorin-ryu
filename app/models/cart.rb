class Cart
  include Mongoid::Document
  include Price

  belongs_to :user
  has_many :cart_items, dependent: :destroy
  
  def in_cart_already(id_of_item)
    cart_items.select { |c_item| c_item.item.id.to_s == id_of_item }
              .first || CartItem.new
  end
end
