class Orderitem < ApplicationRecord
  belongs_to :order
  belongs_to :product

  validates :quantity, presence: true, numericality: { greater_than: 0 }

  def enough_stock?()
    if quantity > stock
      quantity = stock
    else
    end
  end
end
