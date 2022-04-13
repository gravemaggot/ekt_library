# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe PostsController, type: :controller do
  let_it_be(:user) { create(:user) }
  before { login(user) }

  describe 'GET #index' do
    let_it_be(:posts) { create_list(:post, 5) }
    let_it_be(:request_params) { { method: :get, action: :index, format: :json } }

    it 'return 2xx' do
      do_request(request_params)
      expect(response).to have_http_status(:success)
    end

    it 'populates an array of all posts' do
      do_request(request_params)
      expect(assigns(:posts)).to match_array(posts)
    end
  end

  describe 'POST #create' do
    let_it_be(:book) { create(:book) }
    let_it_be(:request_params) do
      { method: :post,
        action: :create,
        options: { title: 'reading', book_id: book.id, user_id: user.id },
        format: :json }
    end
    let_it_be(:request_invalid_params) do
      { method: :post,
        action: :create,
        options: { title: '', book_id: book.id, user_id: user.id },
        format: :json }
    end

    context 'callbacks' do
      before { do_request(request_params) }

      it 'assign the requested book to @book' do
        expect(assigns(:book)).to eq(book)
      end

      it 'assign the requested user to @user' do
        expect(assigns(:user)).to eq(user)
      end

      it 'update book after create post' do
        book.reload
        expect(book.posts.count).not_to eq 0
      end
    end

    context 'with valid attributes' do
      it 'return :created' do
        do_request(request_params)
        expect(response).to have_http_status(:created)
      end

      it 'save new post in the database' do
        expect { do_request(request_params) }
          .to change(Post, :count).by(1)
      end
    end

    context 'with invalid attributes' do
      it 'return :unprocessable_entity' do
        do_request(request_invalid_params)
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'does not save new post in the database' do
        expect { do_request(request_invalid_params) }
          .to_not change(Post, :count)
      end
    end
  end

  describe 'PATCH #close_reading_post' do
    # before do
    #   Rails.application.routes.draw do
    #     patch :readed, to: 'posts#close_reading_post'
    #   end
    # end

    let_it_be(:post) { create(:post) }
    let_it_be(:book) { create(:book, user_id: user.id, posts: [post]) }
    let_it_be(:request_params) do
      { method: :patch,
        action: :close_post,
        options: { id: post.id },
        format: :json }
    end

    before { do_request(request_params) }

    it 'update post' do
      post.reload
      expect(post.active).to eq false
      expect(post.end_date).to_not eq(nil)
    end
  end
end
# rubocop:enable Metrics/BlockLength
