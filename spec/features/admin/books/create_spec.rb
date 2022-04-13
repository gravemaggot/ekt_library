require 'rails_helper'

feature 'Admin can create new book', %q{
  In order add new book to libraries
  As an admin
  I'd like to be able to create new book
}, js: true do

  let_it_be(:admin) { create(:user, admin: 'true') }
  let_it_be(:user) { create(:user) }
  let_it_be(:category) { create(:category) }

  describe 'Admin' do
    background do
      sign_in(admin)
      visit '/admin_books'
    end

    scenario 'can create new book with valid attr' do
      expect(page).to have_content 'Книги(АДМИНИСТРИРОВАНИЕ)'

      click_on 'Новая книга'

      fill_in 'Наименование *', with: 'Test_title'
      fill_in 'Автор *', with: 'Test_author'
      # attach_file '#Обложка', "#{Rails.root}/app/javascript/images/Logo.png"
      fill_in 'Описание', with: 'Test_description'

      all('#Категории').first.click
      find('.q-item__label', text: "#{category.title}").click
      # Add if start status available
      # all('#Статус').first.click
      # find('.q-item__label', text: 'available').click

      click_on 'СОХРАНИТЬ'

      within '.q-table' do
        expect(page).to have_content 'Test_title'.upcase
        expect(page).to have_content 'Test_author'
        expect(page).to have_content category.title
      end
    end

    scenario 'can not create new book with invalid attr' do
      expect(page).to have_content 'Книги(АДМИНИСТРИРОВАНИЕ)'

      click_on 'Новая книга'
      within '.q-form' do
        fill_in 'Наименование *', with: ' '
        click_on 'СОХРАНИТЬ'
      end

      # expect(page).to have_content 'Наименование не может быть пустым!'

      within '.q-table' do
        expect(page).to_not have_content 'Test_title'.upcase
        expect(page).to_not have_content 'Test_author'
      end
    end
  end

  describe 'User' do
    background do
      sign_in(user)
      visit '/admin_books'
    end

    scenario 'do not see new book button' do
      expect(page).to_not have_button 'Новая книга'
    end
  end
end
