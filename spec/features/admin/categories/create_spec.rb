require 'rails_helper'

feature 'Admin can create new category', %q{
  In order to simplify the search books
  As an admin
  I'd like to be able to create new category
}, js: true do

  let_it_be(:admin) { create(:user, admin: 'true') }
  let_it_be(:user) { create(:user) }

  describe 'Admin' do
    background do
      sign_in(admin)
      visit '/admin_categories'
    end

    scenario 'can create new category with valid attr' do
      expect(page).to have_content 'Категории(АДМИНИСТРИРОВАНИЕ)'

      click_on 'Новая категория'

      within '.q-form' do
        fill_in 'Наименование', with: 'Test_title'
        click_on 'СОХРАНИТЬ'
      end

      within '.q-table' do
        expect(page).to have_content 'Test_title'
      end
    end

    scenario 'can not create new category with invalid attr' do
      expect(page).to have_content 'Категории(АДМИНИСТРИРОВАНИЕ)'

      click_on 'Новая категория'

      within '.q-form' do
        fill_in 'Наименование', with: ' '
        click_on 'СОХРАНИТЬ'
      end

      within '.q-table' do
        expect(page).to_not have_content 'Редактировать'
        expect(page).to_not have_content 'Удалить'
      end
    end
  end

  describe 'User can not create category' do
    background do
      sign_in(user)
      visit '/admin_categories'
    end

    scenario 'do not see new category button' do
      expect(page).to_not have_button 'Новая категория'
    end
  end
end
