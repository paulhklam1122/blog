# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# 200.times do
#   p = Post.create title: Faker::Commerce.product_name,
#                 body: Faker::Hacker.say_something_smart + Faker::Hipster.sentence(3)
# end
User.create(first_name: "Paul", last_name: "Lam", email: "paullam007@gmail.com", password: "p", is_admin: true)

User.create(first_name: "Jason", last_name: "Tam", email: "jason@codecore.ca", password: "j")

User.create(first_name: "Corey", last_name: "Lau", email: "ccliu2012@gmail.com", password: "t")

User.create(first_name: "Tofu", last_name: "Tofu", email: "tofu@gmail.com", password: "t")

User.create(first_name: "Panda", last_name: "Panda", email: "panda@gmail.com", password: "p")

["Books", "Music", "Movies", "Games", "Programming", "Cars", "Sports", "Electronics", "Lifestyle", "Cuisine"].each do |cat|
  Category.create title: cat
end

User.all.each do |user|
  50.times do
    user.posts.create(title: Faker::Commerce.product_name, body: Faker::Hacker.say_something_smart + Faker::Hipster.sentence(3), category_id: Category.all.sample.id)
  end
end

#  # Create Comments for Post
Post.all.each do |p|
  5.times do
    comment_user = User.all.map(&:id).sample
    p.comments.create(body: Faker::Company.bs, user_id: comment_user)
  end
end
