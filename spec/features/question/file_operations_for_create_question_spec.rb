require 'acceptance_helper'

feature 'User can perform file operations when he create question', js: true do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  background do
    sign_in(user)
    visit new_question_path
    fill_in 'question_title', with: question.title
    fill_in 'question_body', with: question.body
    click_on I18n.t('cocoon.defaults.add')
  end

  let(:new_object_css) { '#new_question' }
  let(:object_css) { '.question' }
  let(:model) { 'question' }
  it_behaves_like 'Able file operations'
end