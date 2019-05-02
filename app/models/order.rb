class Order < ApplicationRecord
  has_and_belongs_to_many :products
  validates :name, presence: true
  validates :email, presence: true
  validates :address, presence: true
  validates :cc, presence: true
  validates :csv, presence: true
  validates :expiration_date, presence: true
end
