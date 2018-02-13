class Item
  include Mongoid::Document
  attr_accessor :image, :image_cache 
  mount_uploader :image, ImageUploader
  
  field :name, type: String
  field :description, type: String
  field :size, type: Hash
  field :price, type: Float
  field :store_item_id, type: Integer
  field :image, type: String
  

end
