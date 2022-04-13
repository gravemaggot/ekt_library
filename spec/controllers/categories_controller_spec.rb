# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe CategoriesController, type: :controller do
  before { login(create(:user)) }

  describe 'GET #index' do
    let_it_be(:categories) { create_list(:category, 5) }
    let_it_be(:request_params) { { method: :get, action: :index, format: :json } }

    it 'return 2xx' do
      do_request(request_params)
      expect(response).to have_http_status(:success)
    end

    it 'populates an array of all categories' do
      do_request(request_params)
      expect(assigns(:categories)).to match_array(categories)
    end
  end

  describe 'POST #create' do
    let_it_be(:category) { attributes_for(:category) }
    let_it_be(:category_invalid) { attributes_for(:category, :invalid) }
    let_it_be(:request_params) do
      { method: :post,
        action: :create,
        options: category,
        format: :json }
    end
    let_it_be(:request_invalid_params) do
      { method: :post,
        action: :create,
        options: category_invalid,
        format: :json }
    end

    context 'with valid attributes' do
      it 'return :created' do
        do_request(request_params)
        expect(response).to have_http_status(:created)
      end

      it 'save new category in the database' do
        expect { post :create, params: category, format: :js }
          .to change(Category, :count).by(1)
      end
    end

    context 'with invalid attributes' do
      it 'return :unprocessable_entity' do
        do_request(request_invalid_params)
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'does not save new category in the database' do
        expect { post :create, params: category_invalid, format: :js }
          .to_not change(Category, :count)
      end
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: category.id } }

    let_it_be(:category) { create(:category) }

    it 'return 2xx' do
      expect(response).to have_http_status(:success)
    end

    it 'assigns the requested category to @category' do
      expect(assigns(:category)).to eq(category)
    end
  end

  describe 'PATCH #update' do
    let_it_be(:category) { create(:category) }

    it 'return :success' do
      patch :update,
            params: { id: category.id, category: attributes_for(:category) },
            format: :json
      expect(response).to have_http_status(:success)
    end

    context 'with valid attributes' do
      it 'assigns the requested category to @category' do
        patch :update,
              params: { id: category.id, category: attributes_for(:category) },
              format: :json
        expect(assigns(:category)).to eq(category)
      end

      it 'changes category attributes' do
        patch :update,
              params: { id: category.id, title: 'new_title' },
              format: :json
        category.reload

        expect(category.title).to eq('new_title')
      end
    end

    context 'with invalid attributes' do
      it 'does not changes category attributes' do
        patch :update,
              params: { id: category.id,
                        category: attributes_for(:category, :invalid) },
              format: :json
        category.reload

        expect(category.title).to_not eq(nil)
      end
    end
  end

  describe 'DELETE #destroy' do
    let_it_be(:category) { create(:category) }

    it 'return :success' do
      delete :destroy, params: { id: category }
      expect(response).to have_http_status(:success)
    end

    it 'deletes the category' do
      expect { delete :destroy, params: { id: category } }
        .to change(Category, :count).by(-1)
    end
  end
end
# rubocop:enable Metrics/BlockLength
