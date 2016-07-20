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

  scenario 'Removes file of question', js: true do
    within '.question' do
      click_on I18n.t('cocoon.defaults.remove')
      click_on I18n.t('helpers.submit.question.update')
    end

    expect(page).to_not have_link attachment.file.identifier
  end

  scenario 'See current files', js: true do
    within '.attachment-file' do
      expect(page).to have_content attachment.file.identifier
      expect(page).to have_link I18n.t('cocoon.defaults.remove')
    end
  end

  scenario 'Adds file', js: true do
    within '.question' do
      click_on I18n.t('cocoon.defaults.add')
      attach_file('File', "#{Rails.root}/spec/rails_helper.rb")
      click_on I18n.t('helpers.submit.question.update')
      expect(page).to have_xpath("//a[contains(.,'rails_helper.rb')]")
    end
  end
end