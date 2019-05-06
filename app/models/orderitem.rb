class Orderitem < ApplicationRecord
  belongs_to :order
  belongs_to :product

  validates :quantity, presence: true, numericality: { greater_than: 0 }
end

# def quantity_difference
#   return @orderitem.quantity - session[:quantity].to_i
# end
