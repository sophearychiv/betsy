class Merchant < ApplicationRecord
  has_many :products

  validates :username, uniqueness: true, presence: true
  validates :email, uniqueness: true, presence: true

  def self.build_from_github(auth_hash)
    merchant = Merchant.new
    merchant.provider = 'github'
    merchant.username = auth_hash['info']['nickname']
    merchant.email = auth_hash['info']['email']
    merchant.uid = auth_hash['uid']

    return merchant
  end

end
