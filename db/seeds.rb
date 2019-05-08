require "csv"
MERCHANTS_FILE = Rails.root.join("db", "", "merchant_seeds.csv")
puts "Loading raw merchant data from #{MERCHANTS_FILE}"

category_failures = []

categories = ["Bitty Bevs", "Tiny Treats", "Finger Foods", "Bitsy Baubles", "Pint-Sized Plants", "Teeny Tech", "Mini Miscellanies"]
categories.each do |category|
  category_new = Category.new(name: category)

  successful = category_new.save
  if !successful
    category_failures << category_new
    puts "Failed to save category: #{category.inspect}"
  else
    puts "Created category: #{category.inspect}"
  end
end

merchant_failures = []

CSV.foreach(MERCHANTS_FILE, :headers => true) do |row|
  merchant = Merchant.new
  merchant.provider = row["provider"]
  merchant.email = row["email"]
  merchant.username = row["username"]

  successful = merchant.save
  if !successful
    merchant_failures << merchant
    puts "Failed to save media: #{merchant.inspect}"
  else
    puts "Created merchant: #{merchant.inspect}"
  end
end

puts "Added #{Merchant.count} merchant records"
puts "#{merchant_failures.length} merchant failed to save"

PRODUCTS_FILE = Rails.root.join("db", "", "product_seeds.csv")
puts "Loading raw product data from #{PRODUCTS_FILE}"

product_failures = []
CSV.foreach(PRODUCTS_FILE, :headers => true) do |row|
  product = Product.new
  product.name = row["name"]
  product.price = row["price"]
  product.merchant_id = row["merchant_id"]
  product.stock = row["stock"]
  product.description = row["description"]
  product.active = row["active"]
  product.photo_url = row["photo_url"]

  successful = product.save
  if !successful
    product_failures << product
    puts "Failed to save product: #{product.inspect}"
  else
    puts "Created product: #{product.inspect}"
  end
end

puts "Added #{Product.count} product records"
puts "#{product_failures.length} product failed to save"

Product.where(id: 1..5).each do |product|
  product.categories << Category.find_by(name: "Bitty Bevs")
end

Product.where(id: 6..14).each do |product|
  product.categories << Category.find_by(name: "Tiny Treats")
end

Product.where(id: 15..21).each do |product|
  product.categories << Category.find_by(name: "Finger Foods")
end

Product.where(id: 22..24).each do |product|
  product.categories << Category.find_by(name: "Bitsy Baubles")
end

Product.where(id: 25..27).each do |product|
  product.categories << Category.find_by(name: "Pint-Sized Plants")
end

Product.where(id: 28..31).each do |product|
  product.categories << Category.find_by(name: "Teeny Tech")
end

Product.where(id: 32..37).each do |product|
  product.categories << Category.find_by(name: "Mini Miscellanies")
end
