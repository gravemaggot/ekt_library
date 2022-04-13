require 'rails_helper'

feature 'Admin can create new user', %q{
  In order add new user to libraries
  As an admin
  I'd like to be able to create new user
}, js: true do

  let_it_be(:admin) { create(:user, admin: 'true') }
  let_it_be(:user) { create(:user) }

  describe 'Admin' do
    background do
      sign_in(admin)
      visit '/admin_users'
    end

    scenario 'can create new user with valid attr' do
      expect(page).to have_content 'Пользователи(АДМИНИСТРИРОВАНИЕ)'

      click_on 'Новый пользователь'
      within '.q-form' do
        fill_in 'Имя', with: 'FirstName'
        fill_in 'Фамилия', with: 'LastName'
        fill_in 'Email', with: 'usernew@test.com'
        fill_in 'Пароль', with: 'password'
        click_on 'СОХРАНИТЬ'
      end

      within '.q-table' do
        expect(page).to have_content 'FirstName'
        expect(page).to have_content 'LastName'
        expect(page).to have_content 'usernew@test.com'
      end
    end

    scenario 'can not create new user with invalid attr' do
      expect(page).to have_content 'Пользователи(АДМИНИСТРИРОВАНИЕ)'

      click_on 'Новый пользователь'
      within '.q-form' do
        fill_in 'Имя', with: 'FirstName'
        fill_in 'Фамилия', with: ' '
        fill_in 'Email', with: ' '
        fill_in 'Пароль', with: ' '
        click_on 'СОХРАНИТЬ'
      end

      within '.q-table' do
        expect(page).to_not have_content 'FirstName'
      end
    end
  end

  describe 'User can not create user' do
    background do
      sign_in(user)
      visit '/admin_users'
    end

    scenario 'do not see new user button' do
      expect(page).to_not have_button 'Новый пользователь'
    end
  end
end
