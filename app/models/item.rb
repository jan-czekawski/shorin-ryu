class Item
  include Mongoid::Document
  field :name, type: String
  field :description, type: String
  field :size, type: Hash
  field :price, type: Float
  field :item_id, type: Integer
  field :picture, type: String
end
