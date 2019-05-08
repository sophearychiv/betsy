class Order < ApplicationRecord
  has_many :orderitems
  # validates :name, presence: true, allow_nil: true, if: :status_nil?
  validates :name, presence: true, allow_nil: false, unless: :status_nil?
  # validates :email, presence: true, allow_nil: true, if: :status_nil?
  validates :email, presence: true, allow_nil: false, unless: :status_nil?
  validates :address, presence: true, allow_nil: false, unless: :status_nil?
  validates :cc, presence: true, allow_nil: false, unless: :status_nil?
  validates :csv, presence: true, allow_nil: false, unless: :status_nil?
  validates :expiration_date, presence: true, allow_nil: false, unless: :status_nil?

  PENDING = "pending"
  PAID = "paid"
  COMPLETE = "complete"
  CANCELLED = "cancelled"

  def status_nil?
    return true if self.status == nil
  end
end
