class Category < ApplicationRecord

  validates :title, presence: true
  validates_uniqueness_of :title, case_sensitive: false

  has_and_belongs_to_many :books
end
