class Merchant < ApplicationRecord
  STATUSES = %w(Pending Paid Complete Cancelled)

  has_many :products
  has_many :orderitems, through: :products
  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true

  def self.build_from_github(auth_hash)
    return Merchant.new(uid: auth_hash[:uid],
                        provider: "github",
                        email: auth_hash["info"]["email"],
                        username: auth_hash["info"]["name"])
  end

  def items_by_status(status)
    items = self.orderitems.group_by { |oid| oid.order.status }

    available_statuses = items.keys

    if status == "all"
      return items
    else
      if STATUSES.include?(status) && available_statuses.include?(status)
        return items[status]
        # orderitem[status]
      else
        return []
      end
    end
  end

  def self.items_by_orderid(items)
    if items.nil? || items.empty?
      return []
    end
    items = items.group_by { |oi| oi.order.id }
    return items
  end

  def total_revenue
    paid_items = self.items_by_status("Paid")
    complete_items = self.items_by_status("Complete")

    if paid_items.nil?
      revenue_paid = 0
    else
      revenue_paid = paid_items.sum { |oi| oi.total_price }
    end

    if complete_items.nil?
      revenue_complete = 0
    else
      revenue_complete = complete_items.sum { |oi| oi.total_price }
    end

    return revenue_paid + revenue_complete
  end

  def revenue_by_status
    revenue = Hash.new
    paid_items = self.items_by_status("Paid")
    complete_items = self.items_by_status("Complete")

    if paid_items.nil?
      revenue["paid"] = 0
    else
      revenue["paid"] = paid_items.sum { |oi| oi.total_price }
    end

    if complete_items.nil?
      revenue["complete"] = 0
    else
      revenue["complete"] = complete_items.sum { |oi| oi.total_price }
    end

    return revenue
  end

  def orders_by_status(status)
    orders = []

    self.orderitems.each do |item|
      if !orders.include?(Order.where(id: item.order.id)) && item.order.status == status
        orders << item.order
      end
      return orders
    end
  end
end
