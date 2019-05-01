require 'csv'
MERCHANTS_FILE = Rails.root.join('db', '', 'merchant_seeds.csv')
puts "Loading raw merchant data from #{MERCHANTS_FILE}"

merchant_failures = []
CSV.foreach(MERCHANTS_FILE, :headers => true) do |row|
  merchant = Merchant.new
  merchant.provider = row['provider']
  merchant.email = row['email']
  merchant.username = row['username']

  successful = merchant.save
  if !successful
    merchant_failures << work
    puts "Failed to save media: #{merchant.inspect}"
  else
    puts "Created merchant: #{merchant.inspect}"
  end
end

puts "Added #{Merchant.count} merchant records"
puts "#{merchant_failures.length} merchant failed to save"

PRODUCTS_FILE = Rails.root.join('db', '', 'product_seeds.csv')
puts "Loading raw product data from #{PRODUCTS_FILE}"

product_failures = []
CSV.foreach(PRODUCTS_FILE, :headers => true) do |row|
  product = Product.new
  product.name = row['name']
  product.price = row['price']
  product.merchant_id = row['merchant_id']
  product.stock = row['stock']
  product.description = row['description']
  active = row['active']
  photo = row['photo']

  successful = product.save
  if !successful
    product_failures << work
    puts "Failed to save media: #{product.inspect}"
  else
    puts "Created product: #{product.inspect}"
  end
end

puts "Added #{Product.count} product records"
puts "#{product_failures.length} product failed to save"