class Hotel < ApplicationRecord
  has_many :comments, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :users, through: :bookmarks
  has_many :hotel_tags
  has_many :tags, through: :hotel_tags
end
