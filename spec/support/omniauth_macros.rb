module OmniauthMacros
  def mock_auth_hash(provider)
    OmniAuth.config.mock_auth[:facebook] = {
        provider: provider.to_s,
        uid: '1234567',
        info: {
            email: 'user_example@facebook.com',
        },
        credentials: {
            token: 'mock_token',
            secret: 'mock_secret'
        }
    }
  end
end