class OauthCheck
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

  attr_reader :session

  def initialize(session)
    @session = session
  end

  def create_auth(email)
    if email.present? && (email =~ VALID_EMAIL_REGEX)
      session['omniauth']['info']['email'] = email
      auth = OmniAuth::AuthHash.new(session['omniauth'])
      return @user = User.find_for_oauth(auth)
    end
  end
end