require 'rails_helper'

feature 'User create answer' do
  given(:answer) { FactoryGirl.build(:answer) }
  given(:invalid_answer) { FactoryGirl.build(:invalid_answer) }
  given(:user) { FactoryGirl.build(:user) }
  given(:question) { create(:question) }

  context 'Authenticated user create answer' do
    before do
      User.create!(email: user.email, password: user.password)
      visit new_user_session_path
      fill_in 'user_email', with: user.email
      fill_in 'user_password', with: user.password
      click_button 'Log in'
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