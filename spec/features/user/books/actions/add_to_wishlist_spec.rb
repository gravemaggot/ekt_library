require 'rails_helper'

feature 'User can add the book to wishlist', %q{
  In order to create reading list
  As an user
  I'd like to be able to add the book to wishlist
}, js: true do

  let_it_be(:user) { create(:user) }
  let_it_be(:book) { create(:book) }

  describe 'User' do
    background do
      sign_in(user)
      visit '/list_books'
    end

    scenario 'add the book to wishlist' do
      within '.q-table' do
        expect(page).to have_content book.title.upcase

        click_on 'add_to_wish'
        visit '/wish_list'

        expect(page).to have_content book.title.upcase
      end
    end
  end
end
