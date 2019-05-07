class Orderitem < ApplicationRecord
  belongs_to :order
  belongs_to :product

  validates :quantity, presence: true, numericality: { greater_than: 0 }

  def adjust_quantity
    product = self.product
    # if product.stock == 0
    #   self.destroy
    #   return product.stock
    if product.stock < self.quantity
      self.quantity = product.stock
      self.save
      return product.stock
    else
      return self.quantity
    end
  end

  def total_price
    return self.quantity * self.product.price
  end
end
