class PostsController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token
  before_action :load_user,  only: :create
  before_action :load_book,  only: :create
  before_action :load_posts, only: %i[index create]
  before_action :load_post,  only: %i[close_post destroy]

  def index
    # @posts = Post.all
    # render json: @posts
    @posts = Post.readed
    render json: PostSerializer.new(@posts).serialized_json
  end

  def create
    @post = Post.new(post_params)
    @post.user = @user
    @post.book = @book

    if not_uniq?
      render json: { errors: @post.errors }, status: :unprocessable_entity
    else
      if @post.save
        @book.close_booking_post(@user.id) if params[:title] == 'reading'
        render json: @post, status: :created
      else
        render json: { errors: @post.errors }, status: :unprocessable_entity
      end
    end
  end

  def close_post
    @post.update(active: false, end_date: Time.now)
  end

  def destroy
    @post.destroy
  end

  private

  def load_posts
    @posts = Post.all
  end

  def load_post
    @post = Post.find(params[:id])
  end

  def load_user
    @user = params[:user_id].nil? ? current_user : User.find(params[:user_id])
  end

  def load_book
    @book = Book.find(params[:book_id])
  end

  def post_params
    params.permit(:id, :title, :end_date, :active)
  end

  def not_uniq?
    active = @post.title == 'wish' ? false : true

    @posts.exists?(title:   @post.title,
                   book_id: @book.id,
                   user_id: @user.id,
                   active:  active)
  end
end
