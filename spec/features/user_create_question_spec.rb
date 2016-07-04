require 'rails_helper'

feature 'User create question' do
  let(:question) { FactoryGirl.create(:question) }
  let(:invalid_question) { FactoryGirl.build(:invalid_question) }

  scenario 'User create valid question' do
    visit root_path
    click_on 'Create question'
    fill_in 'question_title', with: question.title
    fill_in 'question_body', with: question.body
    click_button 'Create'

    expect(page).to have_content 'Question created successfully'
    expect(current_path).to match /\/questions\/\d+/

    expect(page).to have_content question.title
    expect(page).to have_content question.body
  end

  scenario 'User create invalid question' do
    visit root_path
    click_on 'Create question'
    fill_in 'question_title', with: invalid_question.title
    fill_in 'question_body', with: invalid_question.body
    click_button 'Create'

    expect(page).to have_content 'Create question failed'
    expect(current_path).to eq questions_path
  end
end