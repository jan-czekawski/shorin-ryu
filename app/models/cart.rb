class Cart
  include Mongoid::Document
  include Price

  belongs_to :user
  has_many :cart_items, dependent: :destroy
  
  def current_item(id)
    unless cart_items.empty?
      cart_items.find_by(item_id: id)
    end
  end
end
