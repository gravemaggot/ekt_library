require 'rails_helper'

feature 'Admin can return book', %q{
  In order to fix transfer book
  As an admin
  I'd like to be able to return book
}, js: true do

  given(:admin) { create(:user, admin: 'true') }
  given!(:user) { create(:user) }
  given!(:book) { create(:book, status: 'reading') }
  given!(:post) { create(:post, title: 'reading', book: book, user: user, active: true) }

  describe 'Admin can give out' do
    background do
      sign_in(admin)
      visit '/admin_books'
    end

    # scenario 'booked book' do
    #   within '.q-table' do
    #     expect(page).to have_content book.title.upcase
    #     expect(page).to have_button 'Выдать', disabled: true
    #     expect(page).to have_button 'Вернуть книгу'
    #
    #     click_on 'Вернуть книгу'
    #
    #     expect(page).to have_content 'Доступна'
    #     expect(page).to_not have_content user.first_name
    #     expect(page).to have_button 'Выдать'
    #     expect(page).to have_button 'Вернуть книгу', disabled: true
    #   end
    # end
  end

  describe 'User' do
    background do
      sign_in(user)
      visit '/admin_books'
    end

    # scenario 'can not see return button' do
    #   expect(page).to_not have_button 'Вернуть книгу'
    # end
  end
end