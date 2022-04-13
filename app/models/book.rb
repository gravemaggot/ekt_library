class Book < ApplicationRecord
  include PgSearch::Model

  validates :title,
            :author,
            :description,
            :number_of, presence: true

  has_and_belongs_to_many :categories
  has_one_attached :image
  has_many :posts, dependent: :destroy
  has_many :users, through: :posts
  has_many :comments, dependent: :destroy, counter_cache: true
  has_many :ratings, dependent: :destroy, counter_cache: true

  pg_search_scope :search_by,
                  against: %i[title author],
                  using: {
                    tsearch: { prefix: true }
                  }

  def self.search(query)
    return [] unless query

    search_by(query.to_s)
  end

  # scopes_by_posts_status
  # def booking
  #   scope_by_status('booking', true)
  # end
  #
  # def reading
  #   scope_by_status('reading', true)
  # end
  #
  # def readed
  #   scope_by_status('reading', false)
  # end
  #
  # def wish
  #   scope_by_status('wish', false)
  # end
  #
  # def scope_by_status(title, active)
  #   posts.where(title: title, active: active)
  # end

  def readed_posts
    posts.readed
  end

  # calculating
  def comments_count
    comments.count
  end

  def ratings_count
    ratings.count
  end

  def all_amount
    number_of - posts.reading.count
  end

  def all_amount_with_booking
    number_of - not_available
  end

  def not_available
    posts.booking.count + posts.reading.count
  end

  def calculate_rating
    ratings.sum(&:value) / ratings.count if ratings.exists?
  end

  def calculate_readed
    posts.readed.count if posts.exists?
  end

  def calculate_reading
    posts.reading.count if posts.exists?
  end

  def calculate_booking
    posts.booking.count if posts.exists?
  end

  def calculate_commented
    comments.count if comments.exists?
  end

  ###
  def close_booking_post(user_id)
    active_booking_posts = posts.active&.where(title: 'booking', user_id: user_id)
    active_booking_posts&.each { |p| p.update!(active: false, end_date: Time.now) }
  end

  def reading_users
    posts.reading&.map { |post| post.user }
  end

  # def booking_users_str
  #   booking.map { |post| "#{post.user.last_name} #{post.user.first_name} \" #{post.created_at.to_date} \"" }
  # end

  def available?
    self.all_amount_with_booking > 0
  end

  # def include_reading?(user_id)
  #   self.posts.where(user_id: user_id)
  # end

  def close_reading(user_id)
    post = posts.active&.where(title: 'reading', active: true, user_id: user_id)
    post.update(active: false, end_date: Time.now)
  end

  def active_users
    posts.active&.map { |post| post.user }
  end

  # def active_posts
  #   posts.where(active: true)
  # end
end
