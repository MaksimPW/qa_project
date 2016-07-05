require 'rails_helper'

feature 'User sign in' do
  let(:user) { FactoryGirl.build(:user) }
  let(:invalid_user) { FactoryGirl.build(:invalid_user) }

  scenario 'Refistered user try to sign in' do
    User.create!(email: user.email, password: user.password)
    visit new_user_session_path

    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: user.password
    click_button 'Log in'

    expect(page).to have_content 'Signed in successfully'
    expect(current_path).to eq root_path
  end

  scenario 'Non-Registered user try to sign in' do
    visit new_user_session_path

    fill_in 'user_email', with: invalid_user.email
    fill_in 'user_password', with: invalid_user.password
    click_button 'Log in'

    expect(page).to have_content 'Invalid email or password'
    expect(current_path).to eq new_user_session_path
  end

end