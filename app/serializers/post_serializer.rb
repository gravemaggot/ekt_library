# class PostSerializer < ActiveModel::Serializer
#   attributes :id, :title, :start_date, :end_date
#
#   # belongs_to :book
#   # belongs_to :user
#
#   def start_date
#     object.created_at.to_date
#   end
#
#   def end_date
#     object.end_date&.to_date
#   end
# end

class PostSerializer
  include FastJsonapi::ObjectSerializer

  attributes :id, :title, :start_date, :end_date

  attribute :title_book do |object|
    object.book.title
  end

  attribute :author_book do |object|
    object.book.author
  end

  attribute :user_email do |object|
    object.user.email
  end

  attribute :user_name do |object|
    "#{object.user.last_name} #{object.user.first_name}"
  end

  attribute :start_date do |object|
    object.created_at.to_date
  end

  attribute :end_date do |object|
    object.end_date&.to_date
  end
end
