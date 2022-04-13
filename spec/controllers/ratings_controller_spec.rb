# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe RatingsController, type: :controller do
  let_it_be(:user) { create(:user) }
  before { login(user) }

  describe 'POST #create' do
    let_it_be(:book) { create(:book) }
    let_it_be(:request_params) do
      { method: :post,
        action: :create,
        options: { rating: attributes_for(:rating),
                   book_id: book,
                   user_id: user },
        format: :json }
    end
    let_it_be(:request_invalid_params) do
      { method: :post,
        action: :create,
        options: { rating: attributes_for(:rating, :invalid),
                   book_id: book,
                   user_id: user },
        format: :json }
    end

    context 'with valid attributes' do
      it 'return :created' do
        do_request(request_params)
        expect(response).to have_http_status(:created)
      end

      it 'save new rating in the database' do
        expect { do_request(request_params) }
          .to change(Rating, :count).by(1)
      end

      it 'does not save new rating(second) if user voted earlier' do
        expect { 2.times { do_request(request_params) } }
          .to change(Rating, :count).by(1)
      end
    end

    context 'with invalid attributes' do
      it 'return :unprocessable_entity' do
        do_request(request_invalid_params)
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'does not save new rating in the database' do
        expect { do_request(request_invalid_params) }
          .to_not change(Rating, :count)
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
