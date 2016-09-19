require 'acceptance_helper'

feature 'User can vote answer' do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }
  given!(:own_answer) { create(:answer, question: question, user: user) }

  given(:own_css_selector) { "#answer_#{own_answer.id}" }
  given(:css_selector) { "#answer_#{answer.id}" }

  context 'As auth', :js do
    background do
      sign_in(user)
      visit question_path(question)
    end

    it_behaves_like 'Vote as auth user'

    scenario 'can`t vote for own answer' do
      within "#{own_css_selector}" do
        expect(page).to_not have_content('.vote-up')
        expect(page).to_not have_content('.vote-down')
      end
    end

    scenario 'can`t update other answers before up vote' do
      within "#{css_selector}" do
        find('.vote-up').click
        expect(page).to have_content('1')
      end

      within "#{own_css_selector}" do
        expect(page).to_not have_content('1')
      end
    end
  end

  context 'As un-auth', :js do
    it_behaves_like 'Vote as un-auth user'
  end
end