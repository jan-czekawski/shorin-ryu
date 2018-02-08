FactoryBot.define do
  factory :event do
    name "example_city"
    address({ city: "Example",
              street: "11th street",
              flat_number: 12,
              zip_code: 200192 })
  end

  # factory :user, class: User do
  factory :user do
    email "first@email.com"
    password "password"
    
    factory :admin do
      admin true
    end
  end
end