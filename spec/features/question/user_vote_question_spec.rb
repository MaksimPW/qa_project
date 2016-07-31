require 'acceptance_helper'

feature 'User can vote question' do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:own_question) { create(:question, user: user)}

  context 'As Auth' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'can`t vote for own question', js: true do
      visit question_path(own_question)
      expect(page).to_not have_content('.vote-up')
      expect(page).to_not have_content('.vote-down')
    end

    scenario 'can see rate question', js: true do
      within '.question' do
        expect(page).to have_content('0')
      end
    end

    scenario 'can up vote', js: true do
      within '.question' do
        find('.vote-up').click
        expect(page).to have_css('.vote-up.active')
        expect(page).to have_content('1')
      end
    end

    scenario 'can down vote', js: true do
      within '.question' do
        find('.vote-down').click
        expect(page).to have_css('.vote-down.active')
        expect(page).to have_content('-1')
      end
    end

    scenario 'can undo vote', js: true do
      within '.question' do
        find('.vote-up').click
        find('.vote-up.active').click

        expect(page).to_not have_css('.vote-up.active')
        expect(page).to have_content('0')
      end
    end

    scenario 'can re-vote', js: true do
      within '.question' do
        find('.vote-up').click
        find('.vote-up').click
        find('.vote-up').click

        expect(page).to have_css('.vote-up.active')
        expect(page).to have_content('1')
      end
    end
  end

  context 'As Un-Auth' do
    background do
      visit question_path(question)
    end

    scenario 'can see rate question', js: true do
      within '.question' do
        expect(page).to have_content('0')
      end
    end

    scenario 'can`t vote', js: true do
      expect(page).to_not have_content('.vote-up')
      expect(page).to_not have_content('.vote-down')
    end
  end
end