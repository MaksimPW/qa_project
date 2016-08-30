class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, omniauth_providers: [:facebook, :twitter]

  has_many :authorizations

  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :comments, dependent: :destroy

  def author_of?(object)
    id == object.user_id
  end

  def voted?(object)
    votes.exists?(votable: object)
  end

  def self.find_for_oauth(auth)
    authorization = Authorization.where(provider: auth[:provider], uid: auth[:uid].to_s).first
    return authorization.user if authorization
    return nil if auth[:info][:email].nil?

    email = auth[:info][:email]
    user = User.where(email: email).first
    if user
      user.authorizations.create!(provider: auth[:provider], uid: auth[:uid].to_s)
    else
      password = Devise.friendly_token[0, 16]
      user = User.create!(email: email, password: password, password_confirmation: password)
      user.authorizations.create!(provider: auth[:provider], uid: auth[:uid].to_s)
    end
    user
  end
end