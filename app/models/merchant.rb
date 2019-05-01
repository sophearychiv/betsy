class Merchant < ApplicationRecord
  has_many :products
  has_many :orders
  has_many :orderitems
end
