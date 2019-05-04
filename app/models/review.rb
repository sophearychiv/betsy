class Review < ApplicationRecord
  belongs_to :product

  validates :rating, presence: true,
                     :inclusion => { :in => 1..5,
                                    :message => "must be a number between 1 and 5" }
  validates :body, presence: true
end
