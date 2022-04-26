class ShortedLinks::ShowSerializer < ActiveModel::Serializer
  attributes :id, :url, :title, :url_string, :description, :tag

  attribute(:url_string) { object.unique_key }
  attribute(:tag) { object.category }
end