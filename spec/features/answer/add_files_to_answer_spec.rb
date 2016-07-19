require 'acceptance_helper'

feature 'Add files to answer' do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:answer) { create(:answer, question: question) }

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'User adds file when asks question' do
    fill_in 'answer_body', with: answer.body
    attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
    click_on I18n.t('helpers.submit.answer.create')

    within '.answers' do
      expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/1/rails_helper.rb'
    end
  end


end