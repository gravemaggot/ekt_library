class BooksSerializer
  include FastJsonapi::ObjectSerializer

  attributes :id,
             :title,
             :short_title,
             :author,
             :description,
             :short_description,
             :available,
             :all_amount_with_booking,
             :image_url,
             :calculate_rating,
             :image_src,
             :number_of,
             :comments_count,
             :calculate_readed,
             :calculate_reading,
             :calculate_booking,
             :calculate_rating,
             :all_amount,
             :categories,
             :readed_posts

  # has_many :categories
  # has_many :posts, lazy_load_data: true

  attribute :categories do |object|
    object.categories.map { |c| c }
  end

  attribute :comments do |object|
    object.comments.map { |c| CommentSerializer.new(c) }
  end

  # attribute :posts do |object|
  #   object.posts.map { |c| c }
  # end

  attribute :booking_posts do |object|
    object.posts.booking.map { |c| c }
  end

  attribute :readed_posts do |object|
    object.posts.readed.map { |c| c }
  end

  attribute :reading_posts do |object|
    object.posts.reading.map { |c| c }
  end

  attribute :wish_posts do |object|
    object.posts.wish.map { |c| c }
  end

  attribute :available, &:available?

  attribute :short_title do |object|
    title = object.title.length <= 45 ? object.title : object.title.slice(0, 42).concat('...')
    "#{object.author} - #{title}"
  end

  attribute :short_description do |object|
    descr = object.description
    descr.length <= 300 ? descr : descr.slice(0, 297).concat('...')
  end

  attribute :image_url do |object|
    rails_blob_path(object.image, only_path: true) if object.image.attached?
  end

  attribute :status do |object|
    object.available? ? 'available' : 'not_available'
  end
end
