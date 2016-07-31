require 'acceptance_helper'

feature 'User can vote answer' do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }
  given!(:own_answer) { create(:answer, question: question, user: user) }

  context 'As Auth' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'can`t vote for own answer', js: true do
      within "#answer_#{own_answer.id}" do
        expect(page).to_not have_content('.vote-up')
        expect(page).to_not have_content('.vote-down')
      end
    end

    scenario 'can see rate answer', js: true do
      within "#answer_#{answer.id}" do
        expect(page).to have_content('0')
      end
    end

    scenario 'can up vote', js: true do
      within "#answer_#{answer.id}" do
        find('.vote-up').click
        expect(page).to have_css('.vote-up.active')
        expect(page).to have_content('1')
      end
    end

    scenario 'can`t update other answers before up vote', js: true do
      within "#answer_#{answer.id}" do
        find('.vote-up').click
        expect(page).to have_content('1')
      end

      within "#answer_#{own_answer.id}" do
        expect(page).to_not have_content('1')
      end
    end

    scenario 'can down vote', js: true do
      within "#answer_#{answer.id}" do
        find('.vote-down').click
        expect(page).to have_css('.vote-down.active')
        expect(page).to have_content('-1')
      end
    end

    scenario 'can undo vote', js: true do
      within "#answer_#{answer.id}" do
        find('.vote-up').click
        find('.vote-up.active').click

        expect(page).to_not have_css('.vote-up.active')
        expect(page).to have_content('0')
      end
    end

    scenario 'can re-vote', js: true do
      within "#answer_#{answer.id}" do
        find('.vote-up').click
        find('.vote-up').click
        find('.vote-up').click

        expect(page).to have_css('.vote-up.active')
        expect(page).to have_content('1')
      end
    end
  end

  context 'As Un-Auth', js: true do
    background do
      visit question_path(question)
    end

    scenario 'can see rate answer' do
      within "#answer_#{answer.id}" do
        expect(page).to have_content('0')
      end
    end

    scenario 'can`t vote' do
      expect(page).to_not have_content('.vote-up')
      expect(page).to_not have_content('.vote-down')
    end
  end
end