require 'rails_helper'

feature 'Admin can see all books', %q{
  In order to admin books
  As an admin
  I'd like to be able to see all books
}, js: true do

  let_it_be(:user) { create(:user) }
  let_it_be(:admin) { create(:user, admin: true) }
  let_it_be(:books) { create_list(:book, 5) }

  describe 'Admin' do
    background { sign_in admin }

    scenario 'can see redirect to books admin button' do
      visit root_path

      click_on 'profile'
      within '.q-menu' do
        expect(page).to have_content 'АДМИНИСТРИРОВАНИЕ'
        expect(page).to have_content 'Книги'
      end
    end

    scenario 'can see all books' do
      visit '/admin_books'

      books.each do |book|
        within '.q-table' do
          expect(page).to have_content book.title.upcase
          expect(page).to have_content book.author
        end
      end
    end
  end

  describe 'User' do
    background { sign_in user }

    scenario 'can not see redirect to books admin button' do
      visit root_path

      click_on 'profile'
      within '.q-menu' do
        expect(page).to_not have_content 'АДМИНИСТРИРОВАНИЕ'
        expect(page).to_not have_content 'Книги'
      end
    end

    scenario 'can not see all books in admin table' do
      visit '/admin_books'

      expect(page).to_not have_css '.q-table'
      
      books.each do |book|
        expect(page).to_not have_content book.title.upcase
        expect(page).to_not have_content book.author
      end
    end
  end
end
