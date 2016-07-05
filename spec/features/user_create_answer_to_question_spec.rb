require 'rails_helper'

feature 'User can create answer' do
  let(:answer) { FactoryGirl.build(:answer) }
  let(:invalid_answer) { FactoryGirl.build(:invalid_answer) }

  given(:question) { create(:question) }

  scenario 'with valid attributes' do
    visit question_path(question)

    fill_in 'answer_body', with: answer.body
    click_button 'Create'


    expect(current_path).to eq question_path(question)
    expect(page).to have_content I18n.t('answers.create.success')
    expect(page).to have_content answer.body
  end

  scenario 'with invalid attributes' do
    visit question_path(question)

    fill_in 'answer_body', with: invalid_answer.body
    click_button 'Create'

    expect(page).to have_content I18n.t('answers.create.fail')
  end
end