class CommentsController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token
  before_action :load_book, only: :create
  before_action :load_comment, only: :destroy

  def create
    @comment = @book.comments.new(comment_params)
    @comment.user = current_user

    if @comment.save
      render json: @comment, status: :created
    else
      render json: { errors: @comment.errors }, status: :unprocessable_entity
    end
  end

  # def update
  #   if @comment.update(comment_params)
  #     render json: @comment, status: :created
  #   else
  #     render json: { errors: @comment.errors }, status: :unprocessable_entity
  #   end
  # end

  def destroy
    @comment.destroy
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def load_comment
    @comment ||= Comment.find(params[:id])
  end

  def load_book
    @book = Book.find(params[:book_id])
  end
end
