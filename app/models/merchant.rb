class Merchant < ApplicationRecord
  has_many :products
  has_many :order
  has_many :orderitems
end
