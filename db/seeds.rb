# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create(:email => "kiki@gmail.com", :password => "1234", :money => "0", :role => "admin")
User.create(:email => "gg@ya.ru", :password => "1234", :money => "100", :role => "user")
Category.create(:alias => "football", :title => "Футбол")
Category.create(:alias => "hockey", :title => "Хоккей")
Category.create(:alias => "futsal", :title => "Футзал")
Category.create(:alias => "basketball", :title => "Баскетбол")
Category.create(:alias => "handball", :title => "Гандбол")