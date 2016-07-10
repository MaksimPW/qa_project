require 'rails_helper'

feature 'User sign out' do
  given(:user) { create(:user) }

  scenario 'Auth user try to sign out' do
    sign_in(user)

    click_on 'Sign out'
    expect(page).to_not have_content 'Sign out'
  end

  scenario 'Non-auth user try to sign out' do
    visit root_path
    expect(page).to_not have_content 'Sign out'
  end
end