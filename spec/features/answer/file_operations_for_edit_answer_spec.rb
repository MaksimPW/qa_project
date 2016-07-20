require 'acceptance_helper'

feature 'User can perform file operations when he edit answer', js: true do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given!(:attachment) { create(:attachment, attachable: answer) }

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'Removes file of answer', js: true do
    click_on I18n.t('answers.answer.edit')

    within '.answers' do
      click_on 'Remove file'
      click_on I18n.t('helpers.submit.answer.update')
    end

    expect(page).to_not have_link attachment.file.identifier
  end
end