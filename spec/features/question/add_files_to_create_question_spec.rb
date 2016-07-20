require 'acceptance_helper'

feature 'Add files to question' do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  background do
    sign_in(user)
    visit new_question_path
    fill_in 'question_title', with: question.title
    fill_in 'question_body', with: question.body
  end

  scenario 'User adds file asks question' do
    attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"

    click_button I18n.t('helpers.submit.question.create')

    expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/1/rails_helper.rb'
  end

  scenario 'User adds multiply files asks question', js: true do
    click_on 'Add file'

    inputs = all('input[type="file"]')
    inputs[0].set("#{Rails.root}/spec/rails_helper.rb")
    inputs[1].set( "#{Rails.root}/spec/spec_helper.rb")

    click_button I18n.t('helpers.submit.question.create')

    expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/2/rails_helper.rb'
    expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/3/spec_helper.rb'
  end

  scenario 'User remove one file when it asks question', js: true do
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