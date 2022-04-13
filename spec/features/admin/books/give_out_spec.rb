require 'rails_helper'

feature 'Admin can give out book', %q{
  In order to fix transfer book
  As an admin
  I'd like to be able to give out book
}, js: true do

  given(:admin) { create(:user, admin: 'true') }
  given!(:user) { create(:user) }
  given!(:user_second) { create(:user, first_name: 'FN', last_name: 'LN') }
  given!(:book) { create(:book) }
  given!(:post) { create(:post, title: 'booking', book: book, user: user, active: true) }

  describe 'Admin can give out' do
    background do
      visit new_user_session_path
      sign_in(admin)
      visit '/admin_books'
    end

    # scenario 'booked book' do
    #   within '.q-table' do
    #
    #     expect(page).to have_content book.title.upcase
    #     expect(page).to have_button 'Вернуть книгу', disabled: true
    #
    #     click_on 'Выдать'
    #   end
    #
    #   within '.q-card' do
    #     expect(page).to have_content book.title
    #     expect(page).to have_content user.first_name
    #     click_on 'Выдать'
    #   end
    #
    #   within '.q-table' do
    #     expect(page).to have_content 'На руках'
    #     expect(page).to have_content user.first_name
    #     expect(page).to have_button 'Выдать', disabled: true
    #     expect(page).to have_button 'Вернуть книгу'
    #   end
    # end

    # scenario 'if change user or book not reserved' do
    #   within '.q-table' do
    #     expect(page).to have_content book.title.upcase
    #     expect(page).to have_button 'Вернуть книгу', disabled: true
    #
    #     click_on 'Выдать'
    #   end
    #
    #   within '.q-card' do
    #     expect(page).to have_content book.title
    #     expect(page).to have_content 'Пользователь'
    #     all('#Пользователь').first.click
    #   end
    #
    #   find('.q-item__label', text: "#{user_second.last_name},#{user_second.first_name}").click
    #
    #   within '.q-card' do
    #     click_on 'Выдать'
    #   end
    #
    #   within '.q-table' do
    #     expect(page).to have_content 'На руках'
    #     expect(page).to have_content user_second.first_name
    #     expect(page).to have_button 'Выдать', disabled: true
    #     expect(page).to have_button 'Вернуть книгу'
    #   end
    # end
  end

  describe 'User' do
    background do
      visit new_user_session_path
      sign_in(user)
      visit '/admin_books'
    end

    # scenario 'can not see give out button' do
    #   expect(page).to_not have_button 'Выдать'
    # end
  end
end
