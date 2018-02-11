# users = []
# 10.times do
#   users << "#{Faker::Name.first_name}@gmail.com"
# end

# users.uniq!

# users.each do |user|
#   User.create(email: user, login: user.slice(/\w+(?=@)/),
#               password: "password", password_confirmation: "password")
# end

10.times do
  User.all
      .sample
      .events
      .create(name: Faker::SiliconValley.company,
              address: { city: Faker::Witcher.location,
                         street: Faker::Address.street_name,
                         house_number: Faker::Address.building_number,
                         zip_code: Faker::Address.postcode })
end