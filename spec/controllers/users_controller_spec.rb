# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe Users::IndexController, type: :controller do
  let(:admin) { create(:user, admin: 'true') }
  before { login(admin) }

  describe 'GET #index' do
    let_it_be(:users) { create_list(:user, 5) }
    let_it_be(:request_params) { { method: :get, action: :index, format: :json } }

    it 'return 2xx' do
      do_request(request_params)
      expect(response).to have_http_status(:success)
    end

    it 'populates an array of all users' do
      do_request(request_params)
      users << admin
      expect(assigns(:users)).to match_array(users)
    end
  end

  describe 'GET #me' do
    let_it_be(:request_params) { { method: :get, action: :me, format: :json } }

    it 'return 2xx' do
      do_request(request_params)
      expect(response).to have_http_status(:success)
    end

    it 'return current user' do
      expect(subject.current_user).to eq admin
    end
  end

  describe 'POST #create' do
    let_it_be(:user) { attributes_for(:user) }
    let_it_be(:user_invalid) { attributes_for(:user, :invalid) }
    let_it_be(:request_params) do
      { method: :post, action: :create, options: user, format: :json }
    end
    let_it_be(:request_invalid_params) do
      { method: :post, action: :create, options: user_invalid, format: :json }
    end

    context 'with valid attributes' do
      it 'return :created' do
        do_request(request_params)
        expect(response).to have_http_status(:created)
      end

      it 'save new user in the database' do
        expect { post :create, params: user, format: :js }
          .to change(User, :count).by(1)
      end
    end

    context 'with invalid attributes' do
      it 'return :unprocessable_entity' do
        do_request(request_invalid_params)
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'does not save new user in the database' do
        expect { post :create, params: user_invalid, format: :js }
          .to_not change(User, :count)
      end
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: user.id } }

    let_it_be(:user) { create(:user) }

    it 'return 2xx' do
      expect(response).to have_http_status(:success)
    end

    it 'assigns the requested user to @user' do
      expect(assigns(:user)).to eq(user)
    end
  end

  describe 'PATCH #update' do
    let_it_be(:user) { create(:user) }

    it 'return :success' do
      patch :update,
            params: { id: user.id, user: attributes_for(:user), password: '123456' },
            format: :json
      expect(response).to have_http_status(:success)
    end

    context 'with valid attributes' do
      it 'assigns the requested user to @user' do
        patch :update,
              params: { id: user.id, user: attributes_for(:user), password: '123456' },
              format: :json
        expect(assigns(:user)).to eq(user)
      end

      it 'changes user attributes' do
        patch :update,
              params: { id: user.id,
                        first_name: 'new_first_name',
                        email: 'new@test.com',
                        password: '123456' },
              format: :json
        user.reload

        expect(user.first_name).to eq('new_first_name')
        expect(user.email).to eq('new@test.com')
      end
    end

    context 'with invalid attributes' do
      it 'does not changes user attributes' do
        patch :update,
              params: { id: user.id, user: attributes_for(:user, :invalid) },
              format: :json
        user.reload

        expect(user.first_name).to_not eq(nil)
        expect(user.email).to_not eq(nil)
      end
    end
  end

  describe 'DELETE #destroy' do
    let_it_be(:user) { create(:user) }

    it 'return :success' do
      delete :destroy, params: { id: user }
      expect(response).to have_http_status(:success)
    end

    it 'deletes the user' do
      expect { delete :destroy, params: { id: user } }
        .to change(User, :count).by(-1)
    end
  end
end
# rubocop:enable Metrics/BlockLength
