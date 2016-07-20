require 'acceptance_helper'

feature 'Add files to answer' do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:answer) { create(:answer, question: question) }

  background do
    sign_in(user)
    visit question_path(question)
    fill_in 'answer_body', with: answer.body
  end

  scenario 'User adds file when he answers', js: true do
    attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
    click_on I18n.t('helpers.submit.answer.create')

    within '.answers' do
      expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/1/rails_helper.rb'
    end
  end

  scenario 'User adds multiply files when he answers', js: true do
    click_on 'Add file'

    within '#new_answer' do
      inputs = all('input[type="file"]')
      inputs[0].set("#{Rails.root}/spec/rails_helper.rb")
      inputs[1].set( "#{Rails.root}/spec/spec_helper.rb")
    end

    click_button I18n.t('helpers.submit.answer.create')

    expect(page).to have_xpath("//a[contains(.,'rails_helper.rb')]")
    expect(page).to have_xpath("//a[contains(.,'spec_helper.rb')]")
  end

  scenario 'User remove one file when he answers', js: true do
    click_on 'Add file'

    within '#new_answer' do
      inputs = all('input[type="file"]')
      inputs[0].set("#{Rails.root}/spec/rails_helper.rb")
      inputs[1].set( "#{Rails.root}/spec/spec_helper.rb")
    end

    first('.attachment-file').click_on('Remove file')

    click_button I18n.t('helpers.submit.answer.create')

    expect(page).to_not have_link 'rails_helper.rb'
    expect(page).to have_link 'spec_helper.rb'
  end
end