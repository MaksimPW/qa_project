require 'acceptance_helper'

feature 'User can perform file operations when he create answer' do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:answer) { create(:answer, question: question) }

  background do
    sign_in(user)
    visit question_path(question)
    fill_in 'answer_body', with: answer.body
    click_on I18n.t('cocoon.defaults.add')
  end

  let(:new_object_css) { '#new_answer' }
  let(:object_css) { '.answers' }
  let(:model) { 'answer' }
  it_behaves_like 'Able file operations for create'
end