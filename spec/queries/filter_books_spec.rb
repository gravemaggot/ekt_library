require 'rails_helper' #ToDO: undefined method `joins' for #<Array...

RSpec.describe FilterBooks do
  let!(:user) { create(:user) }

  let!(:reading_post) { create(:post, title: 'reading', user: user, active: true) }
  let!(:reading_book) { create(:book, posts: [reading_post]) }
  let!(:booking_post) { create(:post, title: 'booking', user: user, active: true) }
  let!(:booking_book) { create(:book, posts: [booking_post]) }

  let!(:books) { create_list(:book, 2) }
  # let(:params) do
  #   { :filter => 'all' }
  # end


  describe 'return books' do
    before { books.push(reading_book, booking_book) }

    context 'all' do
      let(:service) { FilterBooks.new(books, user, filter: 'all') }
      it 'return all books array' do
        expect(service.call('')).to match_array(books)
      end
    end

    # context 'reading' do
    #   let!(:service) { FilterBooks.new(books, user, filter: 'reading') }
    #   it 'return all books array' do
    #     expect(service.call('')).to match_array(reading_book)
    #   end
    # end

    # context 'booking' do
    #   let!(:service) { FilterBooks.new(books, user, filter: 'booking') }
    #   it 'return all books array' do
    #     expect(service.call('')).to match_array(booking_book)
    #   end
    # end
  end
end

