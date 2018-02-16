FactoryBot.define do

  sequence :login do |number|
    "John_#{number}"
  end

  factory :user do
    login
    email { "#{login}@gmail.com" }
    password "password"
    
    factory :admin do
      admin true
    end
  end
  
  factory :event do
    name "example_city"
    address({ city: "Example",
              street: "11th street",
              house_number: 12,
              zip_code: 20-192 })
  end
  
  factory :item do
    name "MyString"
    description "MyText"
    size {}
    price 1.0
    store_item_id 32001
    image "MyString"
  end
  
  factory :comment do
  end
  
  factory :size do
  end
  
  factory :address do
  end
  
  factory :cart do
  end
  
  factory :cart_item do
  end
end