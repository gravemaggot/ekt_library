class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :first_name, :last_name, :booking_count, :reading_count, :booking, :reading, :readed, :deactivated, :date_of_deactivation, :full_name_str, :admin, :created_at, :create_date

  # has_many :books

  def booking
    books = []
    object.posts.booking.map do |post|
      books << { title: post.book.title, date: post.created_at.to_date }
    end
    books
  end

  def reading
    books = []
    object.posts.reading.map do |post|
      books << { title: post.book.title, date: post.created_at.to_date }
    end
    books
  end

  def readed
    books = []
    object.posts.readed.map do |post|
      books << { title: post.book.title, date: post.end_date.to_date }
    end
    books
  end

  def booking_count
    booking.count
  end

  def reading_count
    reading.count
  end

  def full_name_str
    "#{object.first_name} #{object.last_name}"
  end

  def create_date
    object.created_at.to_date
  end
end
