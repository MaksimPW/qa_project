require 'acceptance_helper'

feature 'User can view' do
  given(:questions) { create_list :question, 3}
  given!(:question) { questions.first }
  given(:answers) { create_list :answer, 3, question: question }
  given!(:answer) { answers.first }

  scenario 'list questions in Index' do
    visit root_path
    questions.each do |q|
      expect(page).to have_link q.title, href: question_path(q)
    end
  end

  scenario 'list answers in question Show' do
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body

    answers.each do |a|
      expect(page).to have_content answer.body
    end
  end
end