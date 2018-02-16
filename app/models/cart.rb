class Cart
  include Mongoid::Document
  
  belongs_to :user
  
  embeds_many :items
  field :sum, type: Float, default: 0.00
end
