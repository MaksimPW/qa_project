module OmniauthMacros
  def mock_auth_hash_facebook
    OmniAuth.config.mock_auth[:facebook] = {
        provider: 'facebook',
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