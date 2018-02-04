FactoryBot.define do
  # factory :user, class: User do
  factory :user do
    email "first@email.com"
    password "password"
    
    factory :admin do
      admin true
    end
  end
end