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
              flat_number: 12,
              zip_code: 20-192 })
  end
  
end