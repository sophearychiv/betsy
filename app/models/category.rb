class Category < ApplicationRecord
  has_and_belongs_to_many :products

  # unique
  validates :name, presence: true, uniqueness: true
end
