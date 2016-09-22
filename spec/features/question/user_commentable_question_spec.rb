require 'acceptance_helper'

feature 'User can comment question' do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:model) { question }
  given(:object_css) { '.question' }
  given(:other_object_css) { '.answers' }
  it_behaves_like 'Commentable'
end
