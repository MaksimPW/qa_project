require 'rails_helper'

feature 'User create question' do
  given(:question) { FactoryGirl.create(:question) }
  given(:invalid_question) { FactoryGirl.build(:invalid_question) }
  given(:user) { FactoryGirl.build(:user) }

  context 'Authenticated user create question' do
    before do
      User.create!(email: user.email, password: user.password)
      visit new_user_session_path
      fill_in 'user_email', with: user.email
      fill_in 'user_password', with: user.password
      click_button 'Log in'
      click_on 'Create question'
    end

    scenario 'with valid attributes' do
      fill_in 'question_title', with: question.title
      fill_in 'question_body', with: question.body
      click_button 'Create'

      expect(page).to have_content I18n.t('questions.create.success')
      expect(current_path).to match /\/questions\/\d+/

      expect(page).to have_content question.title
      expect(page).to have_content question.body
    end

    scenario 'with invalid attributes' do
      fill_in 'question_title', with: invalid_question.title
      fill_in 'question_body', with: invalid_question.body
      click_button 'Create'

      expect(page).to have_content I18n.t('questions.create.fail')
      expect(current_path).to eq questions_path
    end
  end

  scenario 'Non-authenticated user create question' do
    visit root_path
    click_on 'Create question'

    expect(page).to have_content I18n.t('devise.failure.unauthenticated')
  end
end