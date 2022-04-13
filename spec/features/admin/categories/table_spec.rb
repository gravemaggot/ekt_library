require 'rails_helper'

feature 'Admin can see all categories', %q{
  In order to managment categories
  As an admin
  I'd like to be able to see all categories
}, js: true do

  let_it_be(:admin) { create(:user, admin: 'true') }
  let_it_be(:user) { create(:user) }
  let_it_be(:categories) { create_list(:category, 5) }

  describe 'Admin' do
    background do
      sign_in(admin)
    end

    scenario 'can see redirect to categories admin button' do
      visit root_path

      click_on 'profile'
      within '.q-menu' do
        expect(page).to have_content 'АДМИНИСТРИРОВАНИЕ'
        expect(page).to have_content 'Категории'
      end
    end

    scenario 'show all categories' do
      visit '/admin_categories'

      categories.each do |category|
        within '.q-table' do
          expect(page).to have_content category.title
        end
      end
    end
  end

  describe 'User' do
    background do
      sign_in(user)
    end

    scenario 'can not see redirect to categories admin button' do
      visit root_path

      click_on 'profile'
      within '.q-menu' do
        expect(page).to_not have_content 'АДМИНИСТРИРОВАНИЕ'
        expect(page).to_not have_content 'Категории'
      end
    end

    scenario 'can not see all categories in admin table' do
      visit '/admin_categories'

      expect(page).to_not have_css '.q-table'

      categories.each do |category|
        expect(page).to_not have_content category.title.upcase
      end
    end
  end
end
