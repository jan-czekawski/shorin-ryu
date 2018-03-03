FactoryBot.define do

  # sequence :login { |number| "John_#{number}" }

  factory :user do
    sequence :login { |number| "john_#{number}" }
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
    association :address, strategy: :build
    association :user, strategy: :build
  end
  
  factory :item do
    sequence :store_item_id { |num| num }
    name { "item#{store_item_id}" }
    description "MyText"
    size "xs"
    price 75
    image "MyString"
  end
  
  factory :comment do
    content "random text"
    association :user, strategy: :build
    
    factory :items_comment do
      association :commentable, factory: :item, strategy: :build
    end
    
    factory :events_comment do
      association :commentable, factory: :event, strategy: :build
    end
  end
  
  factory :cart do
    association :user, strategy: :build
  end
  
  factory :cart_item do
    association :cart, strategy: :build
    association :item, strategy: :build
    quantity 300
  end
end