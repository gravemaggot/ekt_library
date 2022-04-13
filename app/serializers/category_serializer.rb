class CategorySerializer < ActiveModel::Serializer
  attributes :id, :title, :book_ids, :books
  # has_many :books
end
