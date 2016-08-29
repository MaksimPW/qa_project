require 'acceptance_helper'

feature 'User sign in with oauth' do
  scenario 'can sign in user with Facebook account', :js do
    visit new_user_session_path
    expect(page).to have_content('Sign in with Facebook')
    mock_auth_hash(:facebook)

    click_on 'Sign in with Facebook'

    expect(page).to have_content I18n.t('devise.omniauth_callbacks.success', kind: 'Facebook')
    expect(current_path).to eq root_path
  end

  scenario 'can sign in user with Facebook account without email', :js do
    visit new_user_session_path
    expect(page).to have_content('Sign in with Facebook')

    mock_auth_hash(:facebook)
    OmniAuth.config.add_mock(:facebook, { info: { email: nil } })

    click_on 'Sign in with Facebook'

    expect(page).to have_content 'Enter your email'
    fill_in 'email', with: 'user_example@example.com'
    click_on 'Send'

    expect(page).to have_content I18n.t('devise.omniauth_callbacks.success', kind: 'Facebook')
    expect(current_path).to eq root_path
  end

  scenario 'can sign in user with Twitter account without email', :js do
    visit new_user_session_path
    expect(page).to have_content('Sign in with Twitter')

    mock_auth_hash(:twitter)
    OmniAuth.config.add_mock(:twitter, { info: { email: nil } })

    click_on 'Sign in with Twitter'

    expect(page).to have_content 'Enter your email'
    fill_in 'email', with: 'user_example@example.com'
    click_on 'Send'

    expect(page).to have_content I18n.t('devise.omniauth_callbacks.success', kind: 'Twitter')
    expect(current_path).to eq root_path
  end

  scenario 'can`t visit new_authorization_path if session wrong', :js do
    visit new_authorization_path

    expect(page).to_not have_content 'Enter your email'
    expect(page).to have_content 'Session wrong'
    expect(current_path).to eq root_path
  end
end