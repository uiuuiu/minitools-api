class AccessTokenSerializer < ActiveModel::Serializer
  attributes :email

  attribute(:email) { object.email }
end