require 'rails_helper'

feature 'User sign up' do
  given(:user) { create(:user) }
  before { visit root_path }

  scenario 'New user try to sign up' do
    click_on 'Sign up'
    fill_in 'user_email', with: 'test_new_user@example.com'
    fill_in 'user_password', with: '876543210'
    fill_in 'user_password_confirmation', with: '876543210'
    click_button 'Sign up'

    expect(current_path).to eq root_path
    expect(page).to have_content I18n.t('devise.registrations.signed_up')
  end

  scenario 'Registered user try to sign up' do
    click_on 'Sign up'
    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: user.password
    fill_in 'user_password_confirmation', with: user.password_confirmation
    click_button 'Sign up'

    expect(page).to_not have_content I18n.t('devise.registrations.signed_up')
  end
end