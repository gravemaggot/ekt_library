# class BookSerializer < ActiveModel::Serializer
#   include Rails.application.routes.url_helpers
#
#   attributes :id,
#              :title,
#              :short_title,
#              :author,
#              :description,
#              :short_description,
#              :available,
#              :all_amount_with_booking,
#              :calculate_rating,
#              :image_src,
#              :comments_count,
#              :ratings_count
#
#   has_many :categories
#   has_many :comments, serializer: CommentSerializer
#
#   def available
#     object.available?
#   end
#
#   def short_title
#     title = object.title.length <= 45 ? object.title : object.title.slice(0, 42).concat('...')
#     "#{object.author} - #{title}"
#   end
#
#   def short_description
#     descr = object.description
#     descr.length <= 300 ? descr : descr.slice(0, 297).concat('...')
#   end
#
#   # def current_rating
#   #   object.calculate_rating
#   # end
#
#   def image_url
#     rails_blob_path(object.image, only_path: true) if object.image.attached?
#   end
#
#   # def image_name
#   #   object.image.filename.to_s
#   # end
#
#   # def string_users
#   #   arr = []
#   #   object.active_users.each do |user|
#   #     string_user = "#{user.last_name} #{user.first_name}"
#   #     arr << string_user
#   #   end
#   #   arr.join(', ')
#   # end
#
#   def status
#     object.available? ? 'available' : 'not_available'
#   end
# end
