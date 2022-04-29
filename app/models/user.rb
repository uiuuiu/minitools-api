class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  include  DeviseTokenAuth::Concerns::User
  
  devise :database_authenticatable, :confirmable, :registerable,
    :recoverable, :rememberable, :validatable,
    :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist
  
  devise :omniauthable, :omniauth_providers => %i[google_oauth2 facebook]

  has_shortened_urls
  has_many :shorted_links, as: :owner

  def jwt_payload
    { id: id }
  end

  def self.signin_or_create_from_provider(provider_data)
    where(provider: provider_data[:provider], uid: provider_data[:uid]).first_or_create do |user|
      user.email = provider_data[:info][:email]
      user.password = Devise.friendly_token[0, 20]
      user.skip_confirmation! # when you signup a new user, you can decide to skip confirmation
    end
  end
end
