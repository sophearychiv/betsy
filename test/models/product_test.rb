require "test_helper"

describe Product do
  let(:product) { products(:product1) }

  it "must be valid" do
    validity = product.valid?
    expect(validity).must_equal true
  end

  it "has required fields" do
    fields = %i(name price merchant_id stock description active photo_url)

    fields.each do |field|
      expect(product).must_respond_to field
    end
  end

  it "can list all of the inactive products" do
    Product.all.each do |product|
      product.active = false
      product.save
    end
  end

  describe "Relationships" do
    it "can have many reviews" do
      reviews = product.reviews
      expect(reviews.length).must_be :>=, 1

      reviews.each do |review|
        expect(review).must_be_instance_of Review
      end
    end

    it "can have many orders" do
      orders = product.orders

      expect(orders.length).must_be :>=, 1
      orders.each do |order|
        expect(order).must_be_instance_of Order
      end
    end

    it "can have many order_items" do
      Orderitem.create(order: orders(:one), product: products(:product1), quantity: 5)
      order_items = product.orderitems

      expect(order_items.length).must_be :>=, 2
      order_items.each do |order_item|
        expect(order_item).must_be_instance_of Orderitem
      end
    end

    it "belongs to a user" do
      merchant = product.merchant
      expect(merchant).must_be_instance_of Merchant
      expect(merchant.id).must_equal product.merchant_id
    end

    it "can have 1 or more categories by shovelling a category into product.categories" do
      category = categories(:food)
      product = products(:product1)
      product.categories << category

      expect(category.products).must_include product
    end

    it "can have 0 categories" do
      categories = product.categories
      expect(categories.length).must_equal 0
    end
  end

  describe "custom methods" do
    let(:product) { products(:product1) }

    it "can list just the active products" do
      expect(Product.active_products.count).must_equal 3
      expect(Product.active_products).wont_include products(:product4)
    end

    it "returns its average rating" do
      expect(product.average_rating).must_equal 5
    end

    it "returns not yet rated if there are no ratings" do
      expect(products(:product3).average_rating).must_equal 0
    end
  end
end
