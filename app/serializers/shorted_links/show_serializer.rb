class ShortedLinks::ShowSerializer < ActiveModel::Serializer
  attributes :id, :title, :url_string, :description, :tag

  attribute(:url_string) { object.unique_key }
  attribute(:tag) { object.category }
end