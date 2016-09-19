require 'acceptance_helper'

feature 'User can vote question' do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:own_question) { create(:question, user: user)}
  given(:css_selector) { '.question' }

  context 'As auth', :js do
    background do
      sign_in(user)
      visit question_path(question)
    end

    it_behaves_like 'Vote as auth user'

    scenario 'can`t vote for own question', :js do
      visit question_path(own_question)
      expect(page).to_not have_content('.vote-up')
      expect(page).to_not have_content('.vote-down')
    end
  end

  context 'As un-auth', :js do
    it_behaves_like 'Vote as un-auth user'
  end
end