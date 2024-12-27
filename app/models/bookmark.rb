class Bookmark < ApplicationRecord
  belongs_to :user
  belongs_to :hotel

  validates :user_id, uniqueness: { scope: :hotel_id }
  validates :hotel_no, presence: true 
  validates :hotel_name, presence: true 
  validates :hotel_information_url, presence: true
end
