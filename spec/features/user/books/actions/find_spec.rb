require 'rails_helper'

feature 'User can find book', %q{
  In order to find the book I need
  As an user
  I'd like to be able to find book by title or author
}, js: true do

  let_it_be(:user) { create(:user) }
  let_it_be(:first_book) { create(:book, title: 'first', author: 'xyxyxyx') }
  let_it_be(:second_book) { create(:book, title: 'second', author: 'zozozo') }

  describe 'User find the book' do
    background do
      sign_in(user)
      visit '/list_books'
    end

    scenario 'by title' do
      within '.q-table-control' do
        expect(page).to have_content 'Поиск'
        fill_in 'Поиск', with: 'fir'
      end
      within '.q-table' do
        expect(page).to have_content first_book.title.upcase
        expect(page).to_not have_content second_book.title.upcase
      end
    end

    scenario 'by author' do
      within '.q-table-control' do
        expect(page).to have_content 'Поиск'
        fill_in 'Поиск', with: 'xyx'
      end
      within '.q-table' do
        expect(page).to have_content first_book.title.upcase
        expect(page).to_not have_content second_book.title.upcase
      end
    end
  end
end
