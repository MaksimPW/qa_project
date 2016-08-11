require 'acceptance_helper'

feature 'Answer editing' do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given(:another_answer) { create(:answer, question: question, user: user) }

  context 'Author try to edit his answer' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'with valid attributes', js: true do
      within "#answer_#{answer.id}" do
        click_link I18n.t('answers.answer.edit')
        fill_in 'answer_body', with: another_answer.body
        click_button I18n.t('helpers.submit.answer.update')
      end

      expect(page).to have_content I18n.t('answers.update.success')
      expect(page).to have_content another_answer.body
      expect(page).to_not have_content answer.body
    end

    scenario 'with invalid attributes', js: true do
      within "#answer_#{answer.id}" do
        click_link I18n.t('answers.answer.edit')
        fill_in 'answer_body', with: ''
        click_button I18n.t('helpers.submit.answer.update')
      end

      expect(page).to have_content 'Body is too short'
      expect(page).to have_content 'Body can\'t be blank'
      expect(page).to have_content answer.body
    end
  end

  scenario 'Authenticated user try to edit other user`s answer', js: true do
    sign_in(create(:user))
    visit question_path(question)

    within "#answer_#{answer.id}" do
      expect(page).to_not have_link I18n.t('answers.answer.edit')
    end
  end

  scenario 'Unauthenticated user try to see edit answer', js: true do
    visit question_path(question)

    within "#answer_#{answer.id}" do
      expect(page).to_not have_link I18n.t('answers.answer.edit')
    end
  end
end