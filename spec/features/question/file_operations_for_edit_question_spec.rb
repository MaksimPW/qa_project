require 'acceptance_helper'

feature 'User can perform file operations when he edit question', js: true do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:attachment) { create(:attachment, attachable: question) }

  background do
    sign_in(user)
    visit question_path(question)
    click_on I18n.t('questions.question.edit')
  end

  let(:objects_css) { '.question' }
  let(:object_css) { '.question' }
  let(:model) { 'question' }
  it_behaves_like 'Able file operations for edit'
end