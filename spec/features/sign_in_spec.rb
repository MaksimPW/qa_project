require 'rails_helper'

feature 'User sign in' do
  given(:user) { create(:user) }
  given(:invalid_user) { build(:invalid_user) }

  scenario 'Registered user try to sign in' do
    sign_in(user)

    expect(page).to have_content 'Signed in successfully'
    expect(current_path).to eq root_path
  end

  scenario 'Non-registered user try to sign in' do
    sign_in(invalid_user)

    expect(page).to have_content 'Invalid email or password'
    expect(current_path).to eq new_user_session_path
  end
end