require 'rails_helper'

feature 'Admin can delete category', %q{
  In order don't publish erroneous information
  As an admin
  I'd like to be able to delete category
}, js: true do

  let_it_be(:admin) { create(:user, admin: 'true') }
  let_it_be(:user) { create(:user) }
  let_it_be(:category) { create(:category) }

  describe 'Admin' do
    background do
      sign_in(admin)
      visit '/admin_categories'
    end

    scenario 'can delete category' do
      expect(page).to have_content 'Категории(АДМИНИСТРИРОВАНИЕ)'

      within '.q-table' do
        expect(page).to have_content category.title

        click_on 'Удалить'
      end

      within '.q-dialog-plugin' do
        click_on 'Да'
      end

      within '.q-table' do
        expect(page).to_not have_content category.title
      end
    end
  end

  describe 'User' do
    background do
      sign_in(user)
      visit '/admin_categories'
    end

    scenario 'can not see delete category button' do
      expect(page).to_not have_button 'Удалить'
    end
  end
end
