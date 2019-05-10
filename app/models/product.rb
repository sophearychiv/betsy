class Product < ApplicationRecord
  has_and_belongs_to_many :categories
  has_many :reviews
  belongs_to :merchant
  has_many :orderitems
  has_many :orders, through: :orderitems

  validates :name, presence: true, uniqueness: { scope: :merchant, message: "Merchant's products must have unique names " }
  validates :price, presence: true, numericality: { greater_than: 0, message: "Price must be greater than 0" }
  validates :stock, presence: true, numericality: { greater_than_or_equal_to: 0, message: "Stock cannot go below 0" }

  def self.active_products
    return Product.where(active: :true)
  end

  def average_rating
    sum = 0
    count = self.reviews.count

    if count == 0
      return 0
    else
      self.reviews.each do |review|
        sum += review.rating
      end

      return (sum * 1.0 / count).round(2)
    end
  end
end
