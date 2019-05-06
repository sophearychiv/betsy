class Orderitem < ApplicationRecord
  belongs_to :order 
  belongs_to :product

  validates :quantity, presence: true, numericality: { greater_than: 0 }


  def total_price
    return self.quantity * self.product.price
  end

end
