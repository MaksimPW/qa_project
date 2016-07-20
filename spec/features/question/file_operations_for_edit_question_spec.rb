require 'acceptance_helper'

feature 'User can perform file operations when he edit question', js: true do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:attachment) { create(:attachment, attachable: question) }

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'Removes file of question', js: true do
    click_on I18n.t('questions.question.edit')

    within '.question' do
      click_on 'Remove file'
      click_on I18n.t('helpers.submit.question.update')
    end

    expect(page).to_not have_link attachment.file.identifier
  end

  scenario 'See current files', js: true do
    click_on I18n.t('questions.question.edit')

    within '.attachment-file' do
      expect(page).to have_content attachment.file.identifier
      expect(page).to have_link 'Remove file'
    end
  end
end