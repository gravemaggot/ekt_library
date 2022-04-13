require 'rails_helper'

feature 'Admin can edit book', %q{
  In order correct information
  As an admin
  I'd like to be able to edit books information
}, js: true do

  let_it_be(:admin) { create(:user, admin: 'true') }
  let_it_be(:user) { create(:user) }
  let_it_be(:book) { create(:book) }

  describe 'Admin' do
    background do
      sign_in(admin)
      visit '/admin_books'
    end

    scenario 'can edit book with valid attr' do
      expect(page).to have_content 'Книги(АДМИНИСТРИРОВАНИЕ)'

      within '.q-table' do
        expect(page).to have_content book.title.upcase
        expect(page).to have_content book.author
        click_on 'Подменю'
      end

      click_on 'Редактировать'

      within '.q-form' do
        fill_in 'Наименование', with: 'Test_new_title'
        fill_in 'Автор', with: 'Test_new_author'
        click_on 'СОХРАНИТЬ'
      end

      within '.q-table' do
        expect(page).to have_content 'Test_new_title'.upcase
        expect(page).to have_content 'Test_new_author'
      end
    end

    scenario 'can not edit book with invalid attr' do
      expect(page).to have_content 'Книги(АДМИНИСТРИРОВАНИЕ)'

      within '.q-table' do
        expect(page).to have_content book.title.upcase
        click_on 'Подменю'
      end

      click_on 'Редактировать'

      within '.q-form' do
        fill_in 'Наименование', with: ' '
        click_on 'СОХРАНИТЬ'
      end

      # expect(page).to have_content 'Наименование не может быть пустым!'

      within '.q-table' do
        expect(page).to have_content book.title.upcase
      end
    end
  end

  describe 'User' do
    background do
      sign_in(user)
      visit '/admin_books'
    end

    scenario 'can not see submenu button and edit book button' do
      expect(page).to_not have_button 'Подменю'
      expect(page).to_not have_button 'Редактировать'
    end
  end
end
