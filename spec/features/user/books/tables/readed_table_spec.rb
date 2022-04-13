require 'rails_helper'

feature 'User can see readed book', %q{
  In order to see readed book
  As a аuthorized user
  I'd like to be able to see my readed book in the special table
}, js: true do

  let_it_be(:user) { create(:user) }
  let_it_be(:book) { create(:book) }
  let_it_be(:readed_book) { create(:book) }
  let_it_be(:readed_post) { create(:post,
                                 title: 'reading',
                                 active: false,
                                 user: user,
                                 book: readed_book) }

  describe 'Authorized user' do
    background do
      sign_in(user)
      visit '/readed_books'
    end

    scenario 'show readed book(without other books)' do
      within '.q-table' do
        expect(page).to_not have_content book.title.upcase
        expect(page).to have_content readed_book.title.upcase
      end
    end
  end
end
