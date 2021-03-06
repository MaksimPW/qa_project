require 'acceptance_helper'

feature 'Question editing' do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:another_question) { create(:question, user: user) }

  context 'Author try to edit his question' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'with valid attributes', js: true do
      within '.question' do
        click_link I18n.t('questions.question.edit')
        fill_in 'question_title', with: another_question.title
        fill_in 'question_body', with: another_question.body
        click_button I18n.t('helpers.submit.question.update')
      end

      expect(page).to have_content I18n.t('flash.actions.update.notice', resource_name: 'Question')

      expect(page).to have_content another_question.title
      expect(page).to have_content another_question.body

      expect(page).to_not have_content question.title
      expect(page).to_not have_content question.body
    end

    scenario 'with invalid attributes', js: true do
      within '.question' do
        click_link I18n.t('questions.question.edit')
        fill_in 'question_title', with: ''
        fill_in 'question_body', with: ''
        click_button I18n.t('helpers.submit.question.update')
      end

      expect(page).to have_content 'Body can\'t be blank'
      expect(page).to have_content 'Body is too short'

      expect(page).to have_content question.title
      expect(page).to have_content question.body
    end
  end

  scenario 'Authenticated user try to edit other user`s question', js: true do
    sign_in(create(:user))
    visit question_path(question)

    within '.question' do
      expect(page).to_not have_link I18n.t('questions.question.edit')
    end
  end

  scenario 'Unauthenticated user try to see edit question', js: true do
    visit question_path(question)

    within '.question' do
      expect(page).to_not have_link I18n.t('questions.question.edit')
    end
  end
end