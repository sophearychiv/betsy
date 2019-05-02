class Product < ApplicationRecord
  has_and_belongs_to_many :categories
  has_many :reviews
  belongs_to :merchant
  has_many :orderitems
  has_many :orders, through: :orderitems

  validates :name, presence: true, uniqueness: { scope: :merchant, message: "Merchant's products must have unique names " }
  validates :price, presence: :true, numericality: { greater_than: 0, message: "Price must be greater than 0" }
  validates :stock, presence: true, numericality: { greater_than_or_equal_to: 0, message: "Stock cannot go below 0" }
  # validates :category, presence: true

  def self.active_products
    return Product.where(active: :true)
  end

  def average_rating
    ratings = 0
    self.reviews.each do |review|
      ratings += review.rating if review.rating
    end
    if ratings == 0
      return "Not yet rated"
    else
      return (ratings.to_i / self.reviews.length).round(2)
    end
  end
end
