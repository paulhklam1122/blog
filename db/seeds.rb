# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# 200.times do
#   Post.create title: Faker::Commerce.product_name,
#                 body: Faker::Hacker.say_something_smart + Faker::Hipster.sentence(3)
# end

["Electronics", "Lifestyle", "Cuisine"].each do |cat|
  Category.create title: cat
end
