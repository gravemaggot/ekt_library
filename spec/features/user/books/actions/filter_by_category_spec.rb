require 'rails_helper'

feature 'User can filter book by category', %q{
  In order to find the book I need
  As an user
  I'd like to be able to filter book by category
}, js: true do

  let_it_be(:user) { create(:user) }
  let_it_be(:first_category) { create(:category, title: 'first_category') }
  let_it_be(:second_category) { create(:category, title: 'second_category') }
  let_it_be(:first_book) { create(:book, categories: [first_category]) }
  let_it_be(:second_book) { create(:book, categories: [second_category]) }
  let_it_be(:third_book) { create(:book) }

  describe 'User filter the book' do
    background do
      sign_in(user)
      visit '/list_books'
    end

    scenario 'by category' do
      all('#Отбор').first.click
      find('.q-item__label', text: "#{first_category.title}").click

      within '.q-table' do
        expect(page).to have_content first_book.title.upcase
        expect(page).to_not have_content second_book.title.upcase
        expect(page).to_not have_content third_book.title.upcase
      end
    end
  end
end
