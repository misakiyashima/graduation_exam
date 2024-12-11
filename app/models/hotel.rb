class Hotel < ApplicationRecord
  has_many :comments, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :bookmarked_by_users, through: :bookmarks, source: :user

end
