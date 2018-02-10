
users = []
100.times do
  users << "#{Faker::Name.first_name}@gmail.com"
end

users.uniq!

users.each do |user|
  User.create(email: user, login: user.slice(/\w+(?=@)/),
              password: "password", password_confirmation: "password")
end