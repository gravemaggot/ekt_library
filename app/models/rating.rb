class Rating < ApplicationRecord
  validates :value, presence: true
  validates :value, inclusion: (1..5)

  belongs_to :book
  belongs_to :user
end
