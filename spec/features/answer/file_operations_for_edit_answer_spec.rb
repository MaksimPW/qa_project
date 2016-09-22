require 'acceptance_helper'

feature 'User can perform file operations when he edit answer', js: true do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given!(:attachment) { create(:attachment, attachable: answer) }

  background do
    sign_in(user)
    visit question_path(question)
    click_on I18n.t('answers.answer.edit')
  end

  given(:objects_css) { '.answers' }
  given(:object_css) { "#answer_#{answer.id}" }
  given(:model) { 'answer' }

  it_behaves_like 'Able file operations for edit'
end