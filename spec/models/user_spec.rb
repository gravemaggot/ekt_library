# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :first_name }
  it { should validate_presence_of :last_name }
  it { should validate_presence_of :password }
  it { should validate_presence_of :email }
  it { should have_many(:posts).dependent(:destroy) }
  it { should have_many(:books).through(:posts) }
  it { should have_many :comments }
  it { should have_many :ratings }

  describe 'uniqueness of email'  do
    subject { User.new(first_name: 'first', last_name: 'last', password: '123456', email: 'test@test.com') }
    it { should validate_uniqueness_of(:email).case_insensitive }
  end

  describe 'Methods' do
    let_it_be(:book) { create(:book) }
    let_it_be(:user) { create(:user) }
    let_it_be(:rating) do
      create(:rating, book_id: book.id, user_id: user.id, value: '5')
    end

    it '#voted(book)' do
      expect(user.voted?(book)).to eq true
    end
  end
end
