# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe BooksController, type: :controller do
  before { login(create(:user)) }

  describe 'GET #index' do
    let_it_be(:books) { create_list(:book, 5) }
    let_it_be(:request_params) do
      { method: :get,
        action: :index,
        options: { filter: 'all' },
        format: :json }
    end

    it 'return 2xx' do
      do_request(request_params)
      expect(response).to have_http_status(:success)
    end

    it 'populates an array of all books' do
      do_request(request_params)
      expect(assigns(:books)).to match_array(books)
    end
  end

  describe 'POST #create' do
    let_it_be(:book) { attributes_for(:book) }
    let_it_be(:book_invalid) { attributes_for(:book, :invalid) }
    let_it_be(:request_params) do
      { method: :post, action: :create, options: book, format: :json }
    end
    let_it_be(:request_invalid_params) do
      { method: :post, action: :create, options: book_invalid, format: :json }
    end

    context 'with valid attributes' do
      it 'return :created' do
        do_request(request_params)
        expect(response).to have_http_status(:created)
      end

      it 'save new book in the database' do
        expect { post :create, params: book, format: :js }
          .to change(Book, :count).by(1)
      end
    end

    context 'with invalid attributes' do
      it 'return :unprocessable_entity' do
        do_request(request_invalid_params)
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'does not save new book in the database' do
        expect { post :create, params: book_invalid, format: :js }
          .to_not change(Book, :count)
      end
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: book.id } }

    let_it_be(:book) { create(:book) }

    it 'return 2xx' do
      expect(response).to have_http_status(:success)
    end

    it 'assigns the requested book to @book' do
      expect(assigns(:book)).to eq(book)
    end
  end

  describe 'PATCH #update' do
    let_it_be(:book) { create(:book) }

    it 'return :success' do
      patch :update,
            params: { id: book.id, book: attributes_for(:book) },
            format: :json
      expect(response).to have_http_status(:success)
    end

    context 'with valid attributes' do
      it 'assigns the requested book to @book' do
        patch :update,
              params: { id: book.id, book: attributes_for(:book) },
              format: :json
        expect(assigns(:book)).to eq(book)
      end

      it 'changes book attributes' do
        patch :update,
              params: { id: book.id, title: 'new_title', author: 'new_author' },
              format: :json
        book.reload

        expect(book.title).to eq('new_title')
        expect(book.author).to eq('new_author')
      end
    end

    context 'with invalid attributes' do
      it 'does not changes book attributes' do
        patch :update,
              params: { id: book.id, book: attributes_for(:book, :invalid) },
              format: :json
        book.reload

        expect(book.title).to_not eq(nil)
        expect(book.author).to_not eq(nil)
      end
    end
  end

  describe 'DElet_it_beE #destroy' do
    let_it_be(:book) { create(:book) }

    it 'return :success' do
      delete :destroy, params: { id: book }
      expect(response).to have_http_status(:success)
    end

    it 'deletes the book' do
      expect { delete :destroy, params: { id: book } }
        .to change(Book, :count).by(-1)
    end
  end
end
# rubocop:enable Metrics/BlockLength
