class Merchant < ApplicationRecord
  has_many :products
  has_many :orders
  has_many :orderitems

  validates :username, uniqueness: true, presence: true
  validates :email, uniqueness: true, presence: true
end
