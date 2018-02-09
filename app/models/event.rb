class Event
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :name, type: String
  field :address, type: Hash
  
  validates :name, presence: true
  validates :address, presence: true
end
