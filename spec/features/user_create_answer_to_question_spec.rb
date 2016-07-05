require 'rails_helper'

feature 'User create answer' do
  given(:answer) { build(:answer) }
  given(:invalid_answer) { build(:invalid_answer) }
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  context 'Authenticated user create answer' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'with valid attributes' do
      fill_in 'answer_body', with: answer.body
      click_button 'Create'

      expect(current_path).to eq question_path(question)
      expect(page).to have_content I18n.t('answers.create.success')
      expect(page).to have_content answer.body
    end

    scenario 'with invalid attributes' do
      fill_in 'answer_body', with: invalid_answer.body
      click_button 'Create'

      expect(page).to have_content I18n.t('answers.create.fail')
    end
  end

  scenario 'Non-authenticated user create answer' do
    visit question_path(question)

    expect(page).to_not have_content I18n.t('questions.show.new_answer')
    expect(page).to_not have_button 'Create Answer'
  end
end