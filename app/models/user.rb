class User < ApplicationRecord
  require 'securerandom'
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable
  before_validation :set_disactive_date, on: :update
  validates :first_name,
            :last_name,
            :password,
            :email, presence: true
  validates_uniqueness_of :email, case_sensitive: false

  has_many :posts, dependent: :destroy
  has_many :books, through: :posts
  has_many :comments
  has_many :ratings

  

  def voted?(book)
    book.ratings.where(user_id: id).exists?
  end

  def set_disactive_date
    self.password ||= SecureRandom.hex(8)

    if deactivated == true && date_of_deactivation.nil?
      self.date_of_deactivation = Time.now.to_date
    elsif deactivated == false && !date_of_deactivation.nil?
      self.date_of_deactivation = nil
    end
  end
end
