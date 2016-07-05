require 'rails_helper'

feature 'User can view' do
  given(:questions) { create_list :question, 3}
  given!(:question) { questions.first }

  scenario 'list questions in Index' do
    visit root_path
    questions.each do |q|
      expect(page).to have_link q.title, href: question_path(q)
    end
  end
end