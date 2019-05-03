class Merchant < ApplicationRecord
  has_many :products

  validates :username, uniqueness: true, presence: true
  validates :email, uniqueness: true, presence: true

  def self.build_from_github(auth_hash)
    return Merchant.new(uid: auth_hash[:uid], provider: "github",
                    email: auth_hash["info"]["email"],
                    username: auth_hash["info"]["name"])
  end

end
