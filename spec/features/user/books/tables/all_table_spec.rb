require 'rails_helper'

feature 'User can see all books', %q{
  In order to find the right book
  As a аuthorized user
  I'd like to be able to see all books
}, js: true do

  let_it_be(:user) { create(:user) }
  let_it_be(:books) { create_list(:book, 5) }

  describe 'Authorized user' do
    background do
      sign_in(user)
      visit '/list_books'
    end

    scenario 'show all books' do
      books.each do |book|
        within '.q-table' do
          expect(page).to have_content book.title.upcase
          expect(page).to have_content book.author
        end
      end
    end
  end
end