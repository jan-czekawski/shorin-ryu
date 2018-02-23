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
  
  factory :address do
    city "home"
    street "random street"
    house_number 22
    zip_code "10-444"
  end
  
  factory :event do
    name "example_city"
    address({ city: "Example",
              street: "11th street",
              house_number: 12,
              zip_code: 20-192 })
    user
  end
  
  factory :item do
    name "MyString"
    description "MyText"
    size "xs"
    price 1.0
    store_item_id 32001
    image "MyString"
  end
  
  factory :comment do
    content "random text"
    item
    user
  end
  
  factory :cart do
  end
  
  factory :cart_item do
  end
end