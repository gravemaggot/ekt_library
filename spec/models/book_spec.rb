# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe Book, type: :model do
  it { should validate_presence_of :title }
  it { should validate_presence_of :author }
  it { should validate_presence_of :description }
  it { should validate_presence_of :number_of }
  it { should have_and_belong_to_many :categories }
  it { should have_many(:posts).dependent(:destroy) }
  it { should have_many(:users).through(:posts) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should have_many(:ratings).dependent(:destroy) }

  it 'has one attached files' do
    expect(Book.new.image).to be_an_instance_of(ActiveStorage::Attached::One)
  end

  describe 'scopes' do
    let_it_be(:user) { create(:user) }
    scopes = %w[booking reading readed wish]

    scopes.each do |scope|
      new_post_name = "#{scope}_post"
      new_book_name = "#{scope}_book"

      let(new_book_name) do
        create(:book)
      end

      let(new_post_name) do
        title = %w[reading readed].include?(scope) ? 'reading' : scope
        active = %w[reading booking].include?(scope)
        b_id = eval(new_book_name).id

        create(:post,
               title: title,
               active: active,
               book_id: b_id,
               user_id: user.id)
      end
    end

    context '--> check each scope return correct post' do
      scopes.each do |scope|
        it "`#{scope}`" do
          ibook = eval "#{scope}_book"
          ipost = eval "#{scope}_post"

          Post.all.each do |post|
            expect(ibook.send(scope)).to     include(post) if post == ipost
            expect(ibook.send(scope)).not_to include(post) if post != ipost
          end
        end
      end
    end
  end

  describe 'Methods' do
    let_it_be(:user) { create(:user) }
    let_it_be(:book) { create(:book, number_of: 5) }
    let_it_be(:post_booking) { create(:post, title: 'booking', active: 'true', book_id: book.id, user_id: user.id) }
    let_it_be(:post_reading) { create(:post, title: 'reading', active: 'true', book_id: book.id, user_id: user.id) }

    it '#all_amount' do
      expect(book.all_amount).to eq(4)
    end

    it '#all_amount_with_booking' do
      expect(book.all_amount_with_booking).to eq(3)
    end

    it '#not_available' do
      expect(book.not_available).to eq(2)
    end

    it '#calculate_rating' do
      1.upto(3) { |num| create(:rating, value: num, book: book) }
      expect(book.calculate_rating).to eq(2)
    end

    it '#calculate_readed' do
      5.times { create(:post, :readed, book: book) }
      expect(book.calculate_readed).to eq(5)
    end

    it '#calculate_commented' do
      5.times { create(:comment, book: book) }
      expect(book.calculate_commented).to eq(5)
    end

    it '#close_booking_post' do
      expect(book.booking.count).to eq 1
      expect(book.booking.first.active).to eq true

      book.close_booking_post(user.id)

      expect(book.booking.count).to eq 0
    end

    it '#reading_users' do
      expect(book.reading_users.first).to eq user
    end

    it '#available?' do
      expect(book.available?).to eq true
      3.times { create(:post, title: 'reading', active: 'true', book_id: book.id, user_id: user.id) }
      expect(book.available?).to eq false
    end

    # it '#include_reading?' do
    #   expect(book.include_reading?(user.id)).to eq post_reading
    #   post_reading.update(active: false)
    #   expect(book.include_reading?(user.id)).to eq nil
    # end

    it '#close_reading' do
      expect(book.reading.count).to eq 1
      expect(book.reading.first.active).to eq true
      reading_post_id = book.reading.first.id

      book.close_reading(user.id)

      expect(book.reading.count).to eq 0
      expect(book.readed.count).to eq 1
      expect(book.readed.first.id).to eq reading_post_id
    end

    it '#active_users' do
      expect(book.active_users.first).to eq user
    end

    it '#active_posts' do
      expect(book.active_posts).to include post_booking
      expect(book.active_posts).to include post_reading
    end
  end
end
# rubocop:enable Metrics/BlockLength
