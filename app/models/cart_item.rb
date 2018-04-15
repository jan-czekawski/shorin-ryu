class CartItem
  include Mongoid::Document
  include HandleErrors
  
  belongs_to :item
  belongs_to :cart, optional: true
  belongs_to :checkout, optional: true
  field :quantity, type: Integer
  
  validates :quantity, numericality: { only_integer: true,
                                       greater_than_or_equal_to: 1 }
  
  class << self
    def check_if_already_in_cart(cart, id_of_item)
      # TODO: refactor
      cart.cart_items.select { |c_item| c_item.item.id.to_s == id_of_item }
                     .first || CartItem.new
    end
    
    def add_to_cart(cart, c_item, page_params)
      # FIXME: try to refactor
      if c_item.persisted?
        c_item[:quantity] += page_params[:quantity].to_i
      else
        c_item = cart.cart_items.build(page_params)
      end
      c_item
    end
  end
end
