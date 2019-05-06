class Orderitem < ApplicationRecord
  STATUS = %w(pending paid complete cancelled)

  belongs_to :order 
  belongs_to :product

  validates :quantity, presence: true, numericality: { greater_than: 0 }


end
