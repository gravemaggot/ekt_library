class Post < ApplicationRecord
  validates :title, presence: true
  validates :title, inclusion: { in: %w[booking reading wish] }

  belongs_to :book
  belongs_to :user

  scope :booking, -> { where(title: 'booking', active: true) }
  scope :reading, -> { where(title: 'reading', active: true) }
  scope :readed, -> { where(title: 'reading', active: false) }
  scope :wish, -> { where(title: 'wish', active: false) }
  scope :active, -> { where(active: true) }
end
