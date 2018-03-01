json.extract! cart, :id, :belongs_to, :has_many, :created_at, :updated_at
json.url cart_url(cart, format: :json)
