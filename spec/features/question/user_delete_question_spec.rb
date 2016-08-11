require 'acceptance_helper'

feature 'User delete question' do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:other_question) { create(:question) }

  scenario 'Author deletes own question' do
    sign_in(user)

    visit question_path(question)
    click_on I18n.t('questions.question.delete')

    expect(current_path).to eq questions_path
    expect(page).to_not have_content question.title
    expect(page).to have_content I18n.t('flash.actions.destroy.notice', resource_name: 'Question')
  end

  scenario 'Author can`t deletes another author question' do
    sign_in(user)

    visit question_path(other_question)
    expect(page).to_not have_content I18n.t('questions.question.delete')
  end
end