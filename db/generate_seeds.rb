require "faker"
require "csv"
CSV.open("../db/merchant_seeds.csv", "w", :write_headers => true,
                                          :headers => ["provider", "email", "username"]) do |csv|
  20.times do
    provider = "github"
    email = Faker::Internet.email
    username = (Faker::Creature::Cat.name).downcase + rand(0..100).to_s
    csv << [provider, email, username]
  end
end
# CSV.open("../db/product_seeds.csv", "w", :write_headers => true,
#   :headers => ["name", "price", "merchant_id", "stock", "description", "active", "photo_url"]) do |csv|
#     100.times do
#         name = Faker::Commerce.product_name
#         price = rand(0..9999)
#         merchant_id = Faker::Number.number(2)
#         stock = rand(0..99)
#         description = Faker::Movies::StarWars.wookiee_sentence
#         active = true
#         photo_url = "lorempixel.com/200/200/animals"
#     csv << [name, price, merchant_id, stock, description, active, photo_url]
#     end
# end
