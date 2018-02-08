class Event
  include Mongoid::Document
  field :name, type: String
  field :address, type: Object
end
