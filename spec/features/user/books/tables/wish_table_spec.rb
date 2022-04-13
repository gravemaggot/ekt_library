require 'rails_helper'

feature 'User can see wish book', %q{
  In order to see wish book
  As a аuthorized user
  I'd like to be able to see my wish book in the wishlist
}, js: true do

  let_it_be(:user) { create(:user) }
  let_it_be(:book) { create(:book) }
  let_it_be(:wish_book) { create(:book) }
  let_it_be(:wish_post) { create(:post,
                                 title: 'wish',
                                 active: false,
                                 user: user,
                                 book: wish_book) }


  describe 'Authorized user' do
    background do
      sign_in(user)
      visit '/wish_list'
    end

    scenario 'show wish book(without other books)' do
      within '.q-table' do
        expect(page).to_not have_content book.title.upcase
        expect(page).to have_content wish_book.title.upcase
      end
    end
  end
end
