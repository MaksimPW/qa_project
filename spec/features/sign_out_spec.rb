require 'rails_helper'

feature 'User sign out' do
  let(:user) { FactoryGirl.build(:user) }

  scenario 'Auth user try to sign out' do
    User.create!(email: user.email, password: user.password)
    visit new_user_session_path

    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: user.password
    click_button 'Log in'

    click_on 'Sign out'
    expect(page).to_not have_content 'Sign out'
  end

  scenario 'Non-Auth user try to sign out' do
    visit root_path
    expect(page).to_not have_content 'Sign out'
  end
end