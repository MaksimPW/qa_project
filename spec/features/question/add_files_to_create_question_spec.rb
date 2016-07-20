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
    attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"

    click_button I18n.t('helpers.submit.question.create')

    expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/1/rails_helper.rb'
  end

  scenario 'User adds multiply files asks question', js: true do
    fill_in 'question_title', with: question.title
    fill_in 'question_body', with: question.body
    click_on 'Add file'

    inputs = all('input[type="file"]')
    inputs[0].set("#{Rails.root}/spec/rails_helper.rb")
    inputs[1].set( "#{Rails.root}/spec/spec_helper.rb")

    click_button I18n.t('helpers.submit.question.create')

    expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/2/rails_helper.rb'
    expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/3/spec_helper.rb'
  end
end