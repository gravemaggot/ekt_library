require 'rails_helper'

feature 'Admin can delete book', %q{
  In order don't publish erroneous information
  As an admin
  I'd like to be able to delete book
}, js: true do

  given(:admin) { create(:user, admin: 'true') }
  given(:user) { create(:user) }
  given!(:book) { create(:book) }

  describe 'Admin' do
    background do
      sign_in(admin)
      visit '/admin_books'
    end

    scenario 'can delete book' do
      expect(page).to have_content 'Книги(АДМИНИСТРИРОВАНИЕ)'

      within '.q-table' do
        expect(page).to have_content book.title.upcase
        expect(page).to have_content book.author
        click_on 'Подменю'
      end

      click_on 'Удалить'

      within '.q-dialog-plugin' do
        click_on 'Да'
      end

      within '.q-table' do
        expect(page).to_not have_content book.title.upcase
        expect(page).to_not have_content book.author
      end
    end
  end

  describe 'User' do
    background do
      sign_in(user)
      visit '/admin_books'
    end

    scenario 'can not see submenu button and delete book button' do
      expect(page).to_not have_button 'Подменю'
      expect(page).to_not have_button 'Удалить'
    end
  end
end
