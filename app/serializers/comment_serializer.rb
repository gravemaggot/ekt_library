# class CommentSerializer < ActiveModel::Serializer
#   attributes :id, :author, :body, :created
#
#   def author
#     "#{object.user.first_name} #{object.user.last_name}"
#   end
#
#   def created
#     object.created_at.to_date
#   end
# end

class CommentSerializer
  include FastJsonapi::ObjectSerializer

  attributes :id, :author, :body, :created

  attribute :author do |object|
    "#{object.user.first_name} #{object.user.last_name}"
  end

  attribute :created do |object|
    object.created_at.to_date
  end
end