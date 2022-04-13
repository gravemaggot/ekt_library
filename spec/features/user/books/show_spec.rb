require 'rails_helper'

feature 'User can see show books form', %q{
  In order to see all information about the book
  As an user
  I'd like to be able to see show books form
}, js: true do

  let_it_be(:user) { create(:user) }
  let_it_be(:book) { create(:book_with_categories, count: 3) }

  describe 'User can see content' do
    background do
      sign_in(user)
      visit '/list_books'
    end

    scenario 'show form if click title in the books table' do
      within '.q-table' do
        expect(page).to have_content book.title.upcase
        find('.q-btn__content', text: "#{book.title.upcase}").click
      end

      within '.q-card' do
        expect(page).to have_content book.title
        expect(page).to have_content book.author
        expect(page).to have_content book.description
        book.categories { |category| expect(page).to have_content category }
      end
    end
  end

  describe 'User in the show form' do
    background do
      sign_in(user)
      visit "/list_books/#{book.id}"
    end

    scenario 'can add to wishlist' do
      within '.q-card' do
        click_on 'add_to_wish'
      end

      # expect(page).to have_content "Книга '#{book.title}' добавлена в избранные!"

      visit '/wish_list'
      expect(page).to have_content book.title.upcase
    end

    scenario 'can cast a vote' do
      within '.q-card' do
        first('.q-rating__icon').click
        expect(page).to have_content 'Оценки 1'
      end
      # expect(page).to have_content 'Ваша оценка 1'
    end

    scenario 'can not cast a vote again' do
      within '.q-card' do
        first('.q-rating__icon').click
        first('.q-rating__icon').click
        expect(page).to have_content 'Оценки 1'
      end
      expect(page).to have_content 'Вы уже голосовали!'
    end

    scenario 'can booking book' do
      within '.q-card' do
        click_on 'Зарезервировать'

        expect(page).to have_content 'НЕ ДОСТУПНА'
        expect(page).to have_button 'Зарезервировать', disabled: true
      end
      expect(page).to have_content "Книга '#{book.title}' зарезервирована!"
    end

    scenario 'can add comment' do
      within '.q-card' do
        find(:css, '.q-editor__content').set('new commentABCXYZ')
        expect(page).to have_content 'new commentABCXYZ'
        click_on 'Добавить комментарий'
      end
      expect(page).to have_content 'Комментарий добавлен!'
    end
  end
end
