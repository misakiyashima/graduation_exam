class Hotel < ApplicationRecord
  has_many :comments, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :users, through: :bookmarks

end
