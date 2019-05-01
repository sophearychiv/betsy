class Order < ApplicationRecord
  has_many :orderitems
  validates :email, presence: true
end
