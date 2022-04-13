require 'rails_helper'

feature 'Admin can edit book', %q{
  In order correct information
  As an admin
  I'd like to be able to edit users information
}, js: true do

  let_it_be(:admin) { create(:user, admin: 'true') }
  let_it_be(:user) { create(:user) }

  describe 'Admin' do
    background do
      sign_in(admin)
      visit '/admin_users'
    end

    scenario 'can edit user with valid attr' do
      expect(page).to have_content 'Пользователи(АДМИНИСТРИРОВАНИЕ)'

      within '.q-table' do
        expect(page).to have_content user.first_name
        expect(page).to have_content user.last_name
        expect(page).to have_content user.email

        page.all('tr')[2].click_button 'Редактировать'
      end

      within '.q-form' do
        fill_in 'Имя', with: 'FirstNameAfterEdit'
        fill_in 'Фамилия', with: 'LastNameAfterEdit'
        fill_in 'Email', with: 'newemail@test.com'
        fill_in 'Пароль', with: '12345678'
        click_on 'СОХРАНИТЬ'
      end

      within '.q-table' do
        expect(page).to have_content 'FirstNameAfterEdit'
        expect(page).to have_content 'LastNameAfterEdit'
        expect(page).to have_content 'newemail@test.com'
      end
    end

    scenario 'can not edit user with invalid attr' do
      expect(page).to have_content 'Пользователи(АДМИНИСТРИРОВАНИЕ)'

      within '.q-table' do
        expect(page).to have_content user.first_name
        expect(page).to have_content user.last_name
        expect(page).to have_content user.email

        page.all('tr')[2].click_button 'Редактировать'
      end

      within '.q-form' do
        fill_in 'Имя', with: 'FirstNameAfterEdit'
        fill_in 'Фамилия', with: ' '
        fill_in 'Email', with: ' '
        click_on 'СОХРАНИТЬ'
      end

      within '.q-table' do
        expect(page).to have_content user.first_name
        expect(page).to have_content user.last_name
        expect(page).to have_content user.email

        expect(page).to_not have_content 'FirstNameAfterEdit'
      end
    end
  end

  describe 'User' do
    background do
      sign_in(user)
      visit '/admin_users'
    end

    scenario 'do not see edit user button' do
      expect(page).to_not have_button 'Редактировать'
    end
  end
end
