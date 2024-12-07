class Bookmark < ApplicationRecord
  belongs_to :user
  belongs_to :hotel

  validates :user_id, uniqueness: { scope: :board_id }
end
