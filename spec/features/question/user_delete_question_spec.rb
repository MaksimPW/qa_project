require 'rails_helper'

feature 'User delete question' do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:other_question) { create(:question, user: create(:user)) }

  scenario 'Author deletes own question' do
    sign_in(user)

    visit question_path(question)
    click_on 'Delete'

    expect(current_path).to eq questions_path
    expect(page).to_not have_content question.title
    expect(page).to have_content I18n.t('questions.delete.success')
  end

  scenario 'Author can\`t deletes another author question' do
    sign_in(user)

    visit question_path(other_question)
    expect(page).to_not have_content 'Delete'
  end
end