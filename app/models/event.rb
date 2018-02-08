class Event
  include Mongoid::Document
  field :name, type: String
  field :address, type: Object
  
  validates :name, presence: true, uniqueness: true
end
