class Event
  include Mongoid::Document
  include Mongoid::Timestamps
  
  belongs_to :user
  
  field :name, type: String
  # field :address, type: Hash
  embeds_one :address
  accepts_nested_attributes_for :address
  
  validates :name, presence: true
  # validates :address, presence: true
  validates_associated :address
end
