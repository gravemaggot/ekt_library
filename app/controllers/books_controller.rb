class BooksController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token
  before_action :load_book, only: %i[show update destroy]

  def index
    books = Book.preload(:categories,
                         :ratings,
                         :image_attachment)
    filter_books = FilterBooks.new(books, current_user, params)
    @books = filter_books.call(filter_permitted_params)
    meta = filter_books.meta

    render json: BooksSerializer.new(@books, { meta: meta }).serialized_json
  end

  def create
    @book = Book.new(book_params)
    attach_main_pic(@book) if book_params[:image].present?

    if @book.save
      render json: BooksSerializer.new(@book).serialized_json, status: :created
    else
      render json: { errors: @book.errors }, status: :unprocessable_entity
    end
  end

  def show
    render json: BooksSerializer.new(@book).serialized_json, status: :ok
  end

  def update
    if @book.update(book_params)
      render json: BooksSerializer.new(@book).serialized_json, status: :created
    else
      render json: { errors: @book.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    @book.destroy
  end

  private

  def attach_main_pic(book)
    book.image.attach(book_params[:image])
  end

  def load_book
    @book ||= Book.preload(comments: :user, categories: :books).find(params[:id])
  end

  def book_params
    params.permit(:id,
                  :title,
                  :description,
                  :author,
                  :image,
                  :image_src,
                  :number_of,
                  :category_ids,
                  category_ids: [])
  end

  def filter_permitted_params
    params.permit(:filter,
                  :page,
                  :rowsPerPage,
                  :sortBy,
                  :descending,
                  category_ids: [])
  end
end
