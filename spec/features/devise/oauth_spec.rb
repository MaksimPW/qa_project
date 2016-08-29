require 'acceptance_helper'

feature 'User sign in with oauth' do
  scenario 'can sign in user with Facebook account', :js do
    visit new_user_session_path
    expect(page).to have_content('Sign in with Facebook')
    mock_auth_hash_facebook

    click_on 'Sign in with Facebook'

    expect(page).to have_content I18n.t('devise.omniauth_callbacks.success', kind: 'Facebook')
    expect(current_path).to eq root_path
  end
end