require 'acceptance_helper'

feature 'User create answer' do
  given(:answer) { build(:answer) }
  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  context 'Authenticated user create answer' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'with valid attributes', js: true do
      fill_in 'answer_body', with: answer.body
      click_button I18n.t('helpers.submit.answer.create')

      expect(current_path).to eq question_path(question)
      expect(page).to have_content I18n.t('answers.create.success')
      expect(page).to have_content answer.body
    end

    scenario 'with invalid attributes', js: true do
      click_button I18n.t('helpers.submit.answer.create')

      expect(page).to have_content 'Body is too short'
      expect(page).to have_content 'Body can\'t be blank'
    end
  end

  scenario 'Non-authenticated user create answer' do
    visit question_path(question)

    expect(page).to_not have_content I18n.t('questions.show.new_answer')
    expect(page).to_not have_button I18n.t('helpers.submit.answer.create')
  end
end