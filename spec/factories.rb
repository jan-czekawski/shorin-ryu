FactoryBot.define do
  # factory :user, class: User do
  factory :user do
    login "first"
    email "first@email.com"
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
              zip_code: 200192 })
  end
end