require 'rails_helper'

feature 'User sign up' do
  let(:user) { FactoryGirl.build(:user) }
  before { visit root_path }

  scenario 'New user try to sign up' do
    click_on 'Sign up'
    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: user.password
    fill_in 'user_password_confirmation', with: user.password
    click_button 'Sign up'

    expect(current_path).to eq root_path
    expect(page).to have_content I18n.t('devise.registrations.signed_up')
  end

  scenario 'Refistered user try to sign up' do
    User.create!(email: user.email, password: user.password)

    click_on 'Sign up'
    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: user.password
    fill_in 'user_password_confirmation', with: user.password
    click_button 'Sign up'

    expect(page).to_not have_content I18n.t('devise.registrations.signed_up')
  end

end