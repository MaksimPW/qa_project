require 'acceptance_helper'

feature 'User can perform file operations when he create question', js: true do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  background do
    sign_in(user)
    visit new_question_path
    fill_in 'question_title', with: question.title
    fill_in 'question_body', with: question.body
    click_on 'Add file'
  end

  scenario 'Adds file' do
    attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
    click_button I18n.t('helpers.submit.question.create')

    expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/1/rails_helper.rb'
  end

  scenario 'Adds multiply files', js: true do
    click_on 'Add file'

    inputs = all('input[type="file"]')
    inputs[0].set("#{Rails.root}/spec/rails_helper.rb")
    inputs[1].set( "#{Rails.root}/spec/spec_helper.rb")

    click_button I18n.t('helpers.submit.question.create')
    save_and_open_page

    expect(page).to have_xpath("//a[contains(.,'rails_helper.rb')]")
    expect(page).to have_xpath("//a[contains(.,'spec_helper.rb')]")
  end

  scenario 'Removes one file', js: true do
    click_on 'Add file'

    inputs = all('input[type="file"]')
    inputs[0].set("#{Rails.root}/spec/rails_helper.rb")
    inputs[1].set( "#{Rails.root}/spec/spec_helper.rb")

    first('.attachment-file').click_on('Remove file')

    click_button I18n.t('helpers.submit.question.create')

    expect(page).to_not have_link 'rails_helper.rb'
    expect(page).to have_link 'spec_helper.rb'
  end
end