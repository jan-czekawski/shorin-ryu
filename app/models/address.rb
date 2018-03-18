class Address
  include Mongoid::Document

  field :city
  field :street
  field :house_number, type: Integer
  field :zip_code

  belongs_to :event, optional: true
  # embedded_in :event, inverse_of: :address
end
