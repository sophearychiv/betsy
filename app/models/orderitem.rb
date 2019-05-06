class Orderitem < ApplicationRecord
  belongs_to :order
  belongs_to :product

  validates :quantity, presence: true, numericality: { greater_than: 0 }

  def self.in_stock?(orderitem)
    product = orderitem.product
    if product.stock < orderitem.quantity
      orderitem.quantity = product.stock
      orderitem.save
      return product.stock
    else
      return orderitem.quantity
    end
  end
end
