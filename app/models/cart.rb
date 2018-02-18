class Cart
  include Mongoid::Document
  
  belongs_to :user
  
  # embedded_in :items
  has_many :cart_items
  field: :quantity, type: Integer, default: 0
  field :sum, type: Float, default: 0.00
end
