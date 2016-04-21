require 'random_data'

# Create users
50.times do
  User.create!(
  email: Faker::Internet.email,
  password: RandomData.random_sentence
  )
end

users = User.all

# Create items
250.times do
  Item.create!(
  name: Faker::Lorem.sentence(3),
  user: users.sample
  )
end

items = Item.all

puts "Seed finished"
puts "#{User.count} users created"
puts "#{Item.count} items created"
