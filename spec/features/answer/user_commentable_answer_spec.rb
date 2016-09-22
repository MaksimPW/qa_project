require 'acceptance_helper'

feature 'User can comment answer' do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answers) { create_list(:answer, 2, question: question) }
  given(:model) { answers.first }
  given(:object_css) { "#answer_#{model.id}" }
  given(:other_object_css) { "#answer_#{answers.last.id}" }
  it_behaves_like 'Commentable'
end