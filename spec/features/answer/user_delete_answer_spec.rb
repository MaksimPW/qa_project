require 'acceptance_helper'

feature 'User delete answer' do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: create(:user))}
  given!(:answer) { create(:answer, user: user, question: question) }
  given!(:other_answer) { create(:answer, user: create(:user), question: question) }

  scenario 'Author deletes own answer', js: true do
    sign_in(user)

    visit question_path(question)

    expect(page).to have_content answer.body
    expect(page).to have_link(I18n.t('answers.answer.delete'), href: "/questions/#{question.id}/answers/#{answer.id}")

    within "#answer_#{answer.id}" do
      click_on I18n.t('answers.answer.delete')
    end

    expect(page).to_not have_content answer.body
    expect(page).to have_content I18n.t('flash.actions.destroy.notice', resource_name: 'Answer')
  end

  scenario 'Author can`t deletes another author answers', js: true do
    sign_in(user)

    visit question_path(question)
    expect(page).to have_content answer.body
    expect(page).to_not have_link(I18n.t('answers.answer.delete'), href: "/questions/#{question.id}/answers/#{other_answer.id}")
  end
end