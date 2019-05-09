class Order < ApplicationRecord
  has_many :orderitems
  validates :name, presence: true, allow_nil: false, unless: :status_nil?
  validates :email, presence: true, allow_nil: false, unless: :status_nil?
  validates :address, presence: true, allow_nil: false, unless: :status_nil?
  validates :cc, presence: true, allow_nil: false, unless: :status_nil?
  validates :csv, presence: true, allow_nil: false, unless: :status_nil?
  validates :expiration_date, presence: true, allow_nil: false, unless: :status_nil?

  PENDING = "Pending"
  PAID = "Paid"
  COMPLETE = "Complete"
  CANCELLED = "Cancelled"

  def status_nil?
    return true if self.status == nil
  end

  def sub_total
    sum = 0
    self.orderitems.each do |item|
      total_item_price = item.product.price * item.quantity
      sum += total_item_price
    end

    return sum
  end

  def tax
    return sub_total * 0.09
  end

  def total
    return tax + sub_total
  end
end
