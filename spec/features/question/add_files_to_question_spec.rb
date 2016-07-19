require 'acceptance_helper'

feature 'Add files to question' do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  background do
    sign_in(user)
    visit new_question_path
  end

  scenario 'User adds file asks question' do
    fill_in 'question_title', with: question.title
    fill_in 'question_body', with: question.body
    attach_file 'question_file', "#{Rails.root}/spec/rails_helper.rb"

    click_button I18n.t('helpers.submit.question.create')

    expect(page).to have_content 'rails_helper.rb'
  end
end