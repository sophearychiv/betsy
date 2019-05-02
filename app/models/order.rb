class Order < ApplicationRecord
  has_many :products, through: :orderitems
  validates :name, presence: true
  validates :email, presence: true
  validates :address, presence: true
  validates :cc, presence: true
  validates :csv, presence: true
  validates :expiration_date, presence: true
end
