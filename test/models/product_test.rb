require "test_helper"

describe Product do
  let(:product) { products(:product1) }

  it "must be valid" do
    validity = product.valid?
    expect(validity).must_equal true
    end

  it 'has required fields' do
    fields = %i(name price merchant_id stock description active photo_url)

    fields.each do |field|
      expect(product).must_respond_to field
    end
  end

  it "returns its average rating" do
    expect(product.average_rating).must_equal 5
  end

  it "returns not yet rated if there are no ratings" do
    expect(products(:product3).average_rating).must_equal 0
  end

  it "can list just the active products" do
    expect(Product.active_products.count).must_equal 3
    expect(Product.active_products).wont_include products(:product4)
  end

  it "can list all of the inactive products" do
    Product.all.each do |product|
      product.active = false
      product.save
    end
  end

describe 'Relationships' do

  it 'can have many reviews' do
    reviews = product.reviews
    expect(reviews.length).must_be :>=, 1

    reviews.each do |review|
      expect(review).must_be_instance_of Review
    end
  end

  it 'can have many orders' do
    orders = product.orders

    expect(orders.length).must_be :>=, 1
    orders.each do |order|
      expect(order).must_be_instance_of Order
    end
  end

  it 'can have many order_items' do
    Orderitem.create(order: orders(:one), product: products(:product1), quantity: 5)
    order_items = product.orderitems

    expect(order_items.length).must_be :>=, 2
    order_items.each do |order_item|
      expect(order_item).must_be_instance_of Orderitem
    end
  end

  it 'belongs to a user' do
    merchant = product.merchant
    expect(merchant).must_be_instance_of Merchant
    expect(merchant.id).must_equal product.merchant_id
  end

# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ #
# ^^^^ NEEDS TESTS FOR CATEGORIES RELATIONSHIP THINGS! ^^^^ #
# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ #
end

describe 'custom methods' do
  let(:product) { products(:product2) }

  # it 'can subtract from inventory if there is enough stock' do
  #   inventory = product.stock
  #   product.sold(1)
  #   expect(product.stock).must_equal inventory - 1
  # end

  # it 'will not reduce stock if there is not enough' do
  #   product.sold(20)
  #   valid = product.save
  #   expect(valid).must_equal false
  # end

  # it 'returns true if inventory is available to fill order' do
  #   product = products(:product2)
  #   quantity = product.stock - 1
  #   expect(result = product.in_stock?(quantity)).must_equal true
  # end

  # it 'returns false if stock is insufficient to fill order' do
  #   product = products(:product2)
  #   quantity = product.stock + 1
  #   expect(product.in_stock?(quantity)).must_equal false

  # end
  # it "returns true if stock is equal to requested quantity" do
  #   product = products(:product2)
  #   quantity = product.stock
  #   expect(product.in_stock?(quantity)).must_equal true
  # end
end
end