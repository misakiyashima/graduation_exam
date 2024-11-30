class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :hotels

  validates :user_id, uniqueness: { scope: :board_id }
end
