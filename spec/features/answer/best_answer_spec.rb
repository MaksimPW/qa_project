require 'acceptance_helper'

feature 'Best answer for question' do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:after_best_answer) { create(:answer, question: question) }
  given!(:answer) { create(:answer, question: question) }
  given!(:first_best_answer) { create(:answer, question: question, best: true) }

  scenario 'Best answer must be to the top', js: true do
    visit question_path(question)

    within '.answers' do
      expect(page.first('div')[:id]).to eq "answer_#{first_best_answer.id}"
    end
  end

  context 'As Author' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'Best answer must be to the top after set best', js: true do
      within "#answer_#{answer.id}" do
        click_link I18n.t('answers.answer.set_best')
        expect(page).to have_content I18n.t('answers.answer.best')
      end

      within '.answers' do
        expect(page.first('div')[:id]).to eq "answer_#{answer.id}"
      end
    end

    scenario 'Set best answer for his question', js: true do
      within "#answer_#{answer.id}" do
        click_link I18n.t('answers.answer.set_best')
        expect(page).to have_content I18n.t('answers.answer.best')
      end

      within "#answer_#{first_best_answer.id}" do
        expect(page).to_not have_content I18n.t('answers.answer.best')
      end

      expect(page).to have_content I18n.t('answers.best.success')
    end
  end

  scenario 'Authenticated user can`t set best answer for not his question', js: true do
    sign_in(create(:user))
    visit question_path(question)

    expect(page).to_not have_content I18n.t('answers.answer.set_best')
  end

  scenario 'Non-authenticated user can`t set best answer for question', js: true do
    visit question_path(question)

    expect(page).to_not have_content I18n.t('answers.answer.set_best')
  end
end